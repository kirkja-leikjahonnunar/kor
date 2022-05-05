extends Node2D

@export var player_prefab : PackedScene
@export var other_player_prefab : PackedScene


func SpawnNewPlayer(game_client_id: int, spawn_point: Vector2):
	print ("World needs to spawn player!")
	if get_tree().get_multiplayer().get_unique_id() == game_client_id:
		print ("Trying to spawn ourself as player...")
		var new_player = player_prefab.instantiate()
		new_player.position = spawn_point
		new_player.name = str(game_client_id)
		$Players.add_child(new_player)
		new_player.set_physics_process(true)
	else:
		if not $Players.has_node(str(game_client_id)):
			var new_other_player = other_player_prefab.instantiate()
			new_other_player.position = spawn_point
			new_other_player.name = str(game_client_id)
			$Players.add_child(new_other_player)

func DespawnPlayer(game_client_id):
	print ("Despawning ", game_client_id)
	get_node("Players/"+str(game_client_id)).queue_free()


#------------------ World State Syncing ----------------------

var last_world_state := 0.0
var interpolation_offset := 100
var world_state_buffer = []

func _physics_process(delta):
	var render_time = Time.get_ticks_msec() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[1].T:
			world_state_buffer.remove(eua0)
		var interpolation_factor = float(render_time - world_state_buffer[0]["T"]) \
							/ float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"])
		for player in world_state_buffer[1].keys():
			if str(player) == "T":
				continue
			if player == multiplayer.get_unique_id():
				continue
			if not world_state_buffer[0].has(player):
				continue
			if $Players.has_node(str(player)):
				print ("Finally updating other player, lerp : ", interpolation_factor)
				#var new_position = world_state_buffer[0][player].P.lerp(world_state_buffer[1][player].P, interpolation_factor)
				var new_position = world_state_buffer[1][player].P
				$Players.get_node(str(player)).MovePlayer(new_position)
			else:
				print("Spawing new other player ", player)
				SpawnNewPlayer(player, world_state_buffer[1][player].P)

func UpdateWorldState(world_state):
	if world_state.T > last_world_state:
		last_world_state = world_state.T
		world_state_buffer.append(world_state)
