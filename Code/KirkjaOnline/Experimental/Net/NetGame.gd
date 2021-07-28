extends Spatial
class_name NetGame

onready var player_spawn_point_a = $PlayerPos1
onready var player_spawn_point_b = $PlayerPos2

func _ready():
	var player_a = preload("res://Experimental/Net/NetPlayer.tscn").instance()

	player_a.set_name(str(get_tree().get_network_unique_id()))
	player_a.set_network_master(get_tree().get_network_unique_id())
	player_a.global_transform = player_spawn_point_a.global_transform
	add_child(player_a)
	
	var player_b = preload("res://Experimental/Net/NetPlayer.tscn").instance()
	player_b.set_name(str(Globals.new_player_id))
	player_b.set_network_master(Globals.new_player_id)
	player_b.global_transform = player_spawn_point_a.global_transform
	add_child(player_b)



#func Init(player_id) -> NetGame:
#	var player_a = preload("res://Experimental/Net/NetPlayer.tscn").instance().Init(player_id)
#
#	player_a.set_name(str(get_tree().get_network_unique_id()))
#	player_a.set_network_master(get_tree().get_network_unique_id())
#	player_a.global_transform = player_spawn_point_a.global_transform
#	add_child(player_a)
#
#
#
#	return self
