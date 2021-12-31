extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1912
var max_players = 100

var game_server_list = {}

func _ready():
	StartServer()

func _process(_delta_time):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("ServerHub started.")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(game_server_id):
	game_server_list["GameServer1"] = game_server_id
	print("GameServer List: " + str(game_server_list))
	
func _Peer_Disconnected(game_server_id):
	print("Game Server: " + str(game_server_id) + " disconnected")
	
func DistributeAuthenticationToken(authentication_token, game_server):
	var game_server_peer_id = game_server_list[game_server]
	rpc_id(game_server_peer_id, "RecieveAuthenticationToken", authentication_token)
