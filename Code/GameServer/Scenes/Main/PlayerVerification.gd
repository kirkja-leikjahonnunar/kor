extends Node

onready var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")


func Start(player_id):
	# TODO: Do all the token sending here later on.
	
	# Assuming a positive token succeeded.
	CreatePlayerContainer(player_id)
	

func CreatePlayerContainer(player_id):
	var new_player_container = player_container_scene.instance()
	new_player_container.name = str(player_id)
	get_parent().add_child(new_player_container, true) # True = When you add to the scene node will human readable guarentee.
	var player_container = get_node("../" + str(player_id))
	FillPlayerContariner(player_container)

func FillPlayerContariner(player_container):
	player_container.player_stats = ServerData.stats_data
