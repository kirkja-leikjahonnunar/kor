extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 2020
var max_players = 100

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func _ready():
	StartServer()

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("Gateway server started.")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func _Peer_Connected(player_id):
	print("User Connected ID: " + str(player_id))

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func _Peer_Disconnected(player_id):
	print("User Disconnected ID: " + str(player_id))
