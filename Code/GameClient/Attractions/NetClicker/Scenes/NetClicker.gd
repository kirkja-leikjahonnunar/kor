extends Control

onready var player_ps = preload("res://Attractions/NetClicker/Scenes/ClickerPlayer.tscn")
onready var playground = $Playground


func AddPlayer(username):
	var clicker_player = player_ps.instance()
	clicker_player.Init(username)

	playground.add_child(clicker_player)
