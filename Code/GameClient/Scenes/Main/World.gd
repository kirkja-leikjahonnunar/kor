extends Node2D

@export var player_prefab : PackedScene
@export var other_player_prefab : PackedScene
#@export var test : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func SpawnNewPlayer(game_client_id: int, spawn_point: Vector2):
	print ("World needs to spawn player!")
	if get_tree().get_multiplayer().get_unique_id() == game_client_id:
		print ("Trying to spawn ourself as player...")
		var new_player = player_prefab.instantiate()
		new_player.position = spawn_point
		new_player.name = str(game_client_id)
		$Players.add_child(new_player)
	else:
		var new_other_player = other_player_prefab.instantiate()
		new_other_player.position = spawn_point
		new_other_player.name = str(game_client_id)
		$Players.add_child(new_other_player)

func DespawnPlayer(game_client_id):
	print ("Despawning ", game_client_id)
	get_node("Players/"+str(game_client_id)).queue_free()

