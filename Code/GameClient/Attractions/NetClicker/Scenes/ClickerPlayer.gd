extends Control

onready var score_label = $Panel/Score
onready var button = $Panel/Button

var score = 0
var player_id



func Init(username):
	button.text = username
	player_id = get_instance_id()


func UpdateScore(delta_score):
	score += delta_score
	

func _on_Button_pressed():
	GameServer.UpdatePlayerScore(1, get_instance_id())
	# TODO: ask the server to update the player score
	# TODO: Then tell everyon else?
	pass # Replace with function body.
