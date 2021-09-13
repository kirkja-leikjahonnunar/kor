extends Node

var network = NetworkedMultiplayerENet.new()
var port = 2021 # TCP & UDP port in between Artemis and Civ IV.
var max_players = 100

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func _ready():
	StartServer()

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started.")
	
	network.connect("peer_connected", self, "PeerConnected")
	network.connect("peer_disconnected", self, "PeerDisconnected")
	
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func PeerConnected(player_id):
	print("User Connected: " + str(player_id))

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
func PeerDisconnected(player_id):
	print("User Disconnected: " + str(player_id))
