extends Node

# Game
var player_id = 0
var game_ja_comecou = false

# UI
var sala_404 = false

# Connection
#var server_url = "@.herokuapp.com/"
#var server_ws_url = "wss://" + server_url + "ws"
var server_url = "127.0.0.1:3000/"
var server_ws_url = "ws://" + server_url + "ws"
var socket = WebSocketPeer.new()
var connected = false
var socket_state = WebSocketPeer.STATE_CLOSED
var room_code = ''
var just_connected = true
var joining = false
var pingable = false
var ping_time = 3
var current_ping_time = 0
	
func _process(delta):
	if connected:
		handle_websocket(delta)
	
func start_game():
	print('sending start game....')
	send_message(Enums.Command.StartGame)
	
func play(jogada):
	print('sending move....')
	send_message(Enums.Command.Play, "," + str(jogada))
	
func played(hand_1, hand_2, vencedor):
	Signals.emit_signal("played", hand_1, hand_2, vencedor)
	
func game_started():
	game_ja_comecou = true
	Signals.emit_signal("game_started")

func reset(sala_n_encontrada = false):
	player_id = 0
	game_ja_comecou = false
	socket.close()
	socket = WebSocketPeer.new()
	connected = false
	socket_state = WebSocketPeer.STATE_CLOSED
	room_code = ''
	just_connected = true
	joining = false
	sala_404 = sala_n_encontrada
	pingable = false
	ping_time = 3
	current_ping_time = 0
	set_process(true)

func destroy_room():
	set_process(false)
	reset()

func create_room(code):
	room_code = code
	connect_to_server()
	
func join_room(code):
	sala_404 = false
	joining = true
	room_code = code
	connect_to_server()
	
func connect_to_server():
	socket.connect_to_url(server_ws_url)
	connected = true
	
func handle_websocket(delta):
	socket.poll()
	ping_server(delta)
	
	socket_state = socket.get_ready_state()
	if socket_state == WebSocketPeer.STATE_OPEN:
		handle_websocket_messages_and_states()
	elif socket_state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		if game_ja_comecou:
			Signals.emit_signal("player_disconnected")
			game_ja_comecou = false
		reset()

func handle_websocket_messages_and_states():
	if just_connected and !joining:
		just_connected = false
		send_message(Enums.Command.CreateRoom, "," + room_code)
	elif just_connected and joining:
		just_connected = false
		send_message(Enums.Command.JoinRoom, "," + room_code)
		
	while socket.get_available_packet_count():
		handle_received_message(socket.get_packet().get_string_from_utf8())

func send_message(code, message = ''):
	socket.put_packet((str(code)+message).to_utf8_buffer())
	
func handle_received_message(message):
	var data = message.split(",")
	var command = data[0]
	match int(command):
		Enums.Command.CreateRoom:
			if data[1] == "1":
				print("Room created by the server!")
				Signals.emit_signal("response_room_created", room_code)
			else:
				print("erro ao criar a sala")
		Enums.Command.JoinRoom:
			if data[1] == "1":
				print("Joined room, starting game...")
				player_id = 1
				start_game()
			else:
				print("sala não encontrada!")
				reset(true)
		Enums.Command.StartGame:
			print("Received game started!")
			get_tree().change_scene_to_file("res://game.tscn")
			game_started()
		Enums.Command.Play:
			print("Received move! " + ",".join(data))
			var hand1 = int(data[1])
			var hand2 = int(data[2])
			var vencedor = int(data[3])
			played(hand1, hand2, vencedor)
		Enums.Command.Pong:
			pass
			
func ping_server(delta):
	if pingable:
		current_ping_time = 0
		pingable = false
		send_message(Enums.Command.Pong)
	else:
		current_ping_time += delta
		if current_ping_time > ping_time:
			pingable = true
	
