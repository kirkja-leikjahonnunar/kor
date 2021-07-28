extends Control
class_name Lobby

#var current_id: int = -1

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "PlayerConnected")
	pass # Replace with function body.


#------------------------------------------------------------------------------
# Host()
#------------------------------------------------------------------------------
func _on_HostButton_pressed() -> void:
	var net = NetworkedMultiplayerENet.new() # Godot networking system.
	net.create_server(5432, 2) # (port: int = [0 - 65535], max_clients: int = [2 - 4096]
	get_tree().set_network_peer(net)
	print("hosting")

#------------------------------------------------------------------------------
# Join()
#------------------------------------------------------------------------------
func _on_JoinButton_pressed() -> void:
	var net = NetworkedMultiplayerENet.new() # Godot networking system.
	net.create_client("127.0.0.1", 5432) # (ip: localhost, port: int = 5432)
	get_tree().set_network_peer(net)
	print("joined")

#------------------------------------------------------------------------------
# PlayerConnected()
#------------------------------------------------------------------------------
func PlayerConnected(id: int) -> void:
	Globals.player_id = id # Store for next time.
	print("Player %s connected." % id)
	
	var game = preload("res://Experimental/Net/NetGame.tscn").instance()
	get_tree().get_root().add_child(game) # Add game as a child of the Lobby.
	
	self.hide()
