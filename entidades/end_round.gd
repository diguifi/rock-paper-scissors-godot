extends Node2D

@onready var player1_sprite = $Player1
@onready var player2_sprite = $Player2
@onready var animation = $AnimationPlayer
@onready var label = $Label
@onready var timer = $Timer
var round_winner = -1

const rock = preload("res://assets/rock.png")
const paper = preload("res://assets/paper.png")
const scissors = preload("res://assets/scissors.png")

func _ready():
	Signals.connect('end_round', _end_round)

func _end_round(jogada1, jogada2, winner):
	player1_sprite.set_texture(calcula_sprite(jogada1))
	player2_sprite.set_texture(calcula_sprite(jogada2))
	round_winner = winner
	animation.play('jogada')
	timer.start()

func calcula_sprite(jogada):
	var sprite = rock
	if jogada == Enums.Jogada.Papel:
		sprite = paper
	if jogada == Enums.Jogada.Tesoura:
		sprite = scissors
	return sprite


func _on_animation_player_animation_finished(anim_name):
	if round_winner == Client.player_id:
		label.text = 'You Win!'
	elif round_winner == 3:
		label.text = 'Tie!'
	else:
		label.text = 'You Lose'

func _on_timer_timeout():
	reset()
	Signals.emit_signal('new_round')
	
func reset():
	animation.stop()
	label.text = ''
	round_winner = -1
