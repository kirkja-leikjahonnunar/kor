extends Node

@onready var player_container_scene := preload("res://Scenes/Instances/PlayerContainer.tscn")


func Start(game_client_id: int):
	#.... FIRST do token verification of player
	CreatePlayerContainer(game_client_id)
	
	
func CreatePlayerContainer(game_client_id):
	var new_player_container = player_container_scene.instantiate()
	new_player_container.name = str(game_client_id)
	get_parent().add_child(new_player_container, true)
	var player_container = get_node("../" + str(game_client_id))
	FillPlayerContainer(player_container)

func FillPlayerContainer(_player_container):
	#player_container.player_stats = ServerData.test_data.Stats
	pass


