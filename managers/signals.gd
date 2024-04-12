extends Node

signal response_room_created #server
signal request_start_game #client
signal response_start_game #server
signal response_game_started #server
signal request_play #client
signal response_played #server

signal game_started #ui
signal played #ui
signal played_button #ui
signal end_round #ui
signal new_round #ui
signal player_disconnected #ui
