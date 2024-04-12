extends Node2D

@onready var code = $TextEdit
@onready var join_btn = $Entrar
@onready var invite_btn = $Convidar
var characters = 'abcdefghijklmnopqrstuvwxyz0123456789'

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect('response_room_created', _created_room)

func _on_text_edit_text_changed():
	if code.text.length() > 4:
		code.text = code.text.left(code.text.length() - 1)
		code.set_caret_column(4)

func _created_room(room_code):
	code.text = room_code
	code.editable = false

func _on_entrar_pressed():
	invite_btn.disabled = true
	Client.join_room(code.text)

func _on_convidar_pressed():
	join_btn.disabled = true
	invite_btn.disabled = true
	var room_code = generate_room_code(4)
	Client.create_room(room_code)

func generate_room_code(length):
	var word: String
	var n_char = len(characters)
	for i in range(length):
		word += characters[randi()% n_char]
	return word
