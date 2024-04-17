extends Node2D

@onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect('new_round', _new_round)
	audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _new_round():
	audio.play()
