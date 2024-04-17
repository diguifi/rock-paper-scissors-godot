extends Node2D

@onready var pontos1 = $PontosPlayer1
@onready var pontos2 = $PontosPlayer2

func _ready():
	if Client.player_id == 1:
		var temp = pontos1
		pontos1 = pontos2
		pontos2 = temp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pontos1.text = str(Globals.pontos_player1)
	pontos2.text = str(Globals.pontos_player2)
