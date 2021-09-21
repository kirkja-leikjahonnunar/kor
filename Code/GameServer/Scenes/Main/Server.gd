extends Node

var network = NetworkedMultiplayerENet.new()
var port = 2019
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


remote func Print(message):
	print(message)
	
remote func FetchPlayerPassword(username, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var password = ServerData.player_data[username].player_password
	rpc_id(player_id, "ReturnPlayerPassword", password, requester)
	print("Sending to: %s: %s" % player_id, password)
