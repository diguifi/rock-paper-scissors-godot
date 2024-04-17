extends Node

var sua_jogada = -1
var jogada_oponente = 1
var pontos_player1 = 0
var pontos_player2 = 0
var playing_animation = false

func _ready():
	Signals.connect('new_round', _new_round)
	Signals.connect('played', _played)

func jogar(jogada):
	if sua_jogada == -1:
		sua_jogada = jogada
		Client.play(jogada)

func ambos_jogaram():
	return sua_jogada != -1 && jogada_oponente != -1

func exibir_resultado(vencedor):
	Signals.emit_signal('end_round',sua_jogada,jogada_oponente,vencedor)
	if vencedor == 0:
		pontos_player1 += 1
	elif vencedor == 1:
		pontos_player2 += 1
	
func _played(hand_1, hand_2, vencedor):
	preencher_jogada_oponente(hand_1, hand_2)
	if vencedor != -1:
		exibir_resultado(vencedor)
		
func preencher_jogada_oponente(hand_1, hand_2):
	if Client.player_id == 0:
		jogada_oponente = hand_2
	else:
		jogada_oponente = hand_1

func _new_round():
	sua_jogada = -1
	jogada_oponente = 1
