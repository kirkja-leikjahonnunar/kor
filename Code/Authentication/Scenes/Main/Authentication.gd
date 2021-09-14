extends Node

var network = NetworkedMultiplayerENet.new()
var port = 2021
var max_servers = 5


func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	print("Authentication server started.")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(gateway_id):
	print("Gateway " + str(gateway_id) + " connected.")
	
func _Peer_Disconnected(gateway_id):
	print("Gateway " + str(gateway_id) + " disconnected.")
	
remote func AuthenticatePlayer(username, password, player_id):
	pass
