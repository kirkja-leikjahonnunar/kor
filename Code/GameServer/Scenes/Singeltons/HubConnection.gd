extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 1912

onready var game_server = get_node("/root/GameServer")

func _ready():
	ConnectToAuthentictionServer()
	
func _process(_delta_time):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func ConnectToAuthentictionServer():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	network.connect("connection_failed", self, "_OnConnectionFailed")
	
func _OnConnectionSucceeded():
	print("Succesdully connected to Game Server Hub.")

func _OnConnectionFailed():
	print("Failed to connected to Game Server Hub.")

remote func RecieveAuthenticationToken(auth_token):
	game_server.expected_tokens.append(auth_token)
	#print("Appending token: %s" % game_server.expected_tokens)
	
