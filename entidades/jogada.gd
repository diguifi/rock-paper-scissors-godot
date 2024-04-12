extends TextureButton

# 1 - pedra, 2 - papel, 3 - tesoura
@export var tipo = Enums.Jogada.Pedra
const rock = preload("res://assets/rock.png")
const rock_selected = preload("res://assets/rock_selected.png")
const paper = preload("res://assets/paper.png")
const paper_selected = preload("res://assets/paper_selected.png")
const scissors = preload("res://assets/scissors.png")
const scissors_selected = preload("res://assets/scissors_selected.png")

func _ready():
	Signals.connect('played_button', _played_button)
	Signals.connect('end_round', _end_round)
	Signals.connect('new_round', _new_round)

func _on_pressed():
	Globals.jogar(tipo)
	selecionar_botao(Globals.sua_jogada == tipo)
	
func _played_button():
	disabled = true

func _end_round(jogada1,jogada2,winner):
	visible = false

func selecionar_botao(selecionar = true):
	var sprite = rock
	if selecionar:
		if tipo == Enums.Jogada.Pedra:
			sprite = rock_selected
		if tipo == Enums.Jogada.Papel:
			sprite = paper_selected
		if tipo == Enums.Jogada.Tesoura:
			sprite = scissors_selected
	else:
		if tipo == Enums.Jogada.Pedra:
			sprite = rock
		if tipo == Enums.Jogada.Papel:
			sprite = paper
		if tipo == Enums.Jogada.Tesoura:
			sprite = scissors

	set_texture_normal(sprite)
	if selecionar:
		Signals.emit_signal('played_button')

func _new_round():
	visible = true
	selecionar_botao(false)
	disabled = false
