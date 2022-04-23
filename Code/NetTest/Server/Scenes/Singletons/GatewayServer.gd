extends Node

# GatewayServer on GatewayServer project
#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var gateway_api = MultiplayerAPI.new()
var port := 1910
var max_players := 100


func _ready():
	StartServer()


func _process(_delta):
	if not custom_multiplayer.has_multiplayer_peer():
		return
	custom_multiplayer.poll()


func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	#custom_multiplayer.set_root_node(self) TODO: IS THIS NECESSARY?
	custom_multiplayer.set_root_path("/root/GatewayServer")
	custom_multiplayer.set_multiplayer_peer(network)
	print ("Gateway server started!")
	
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)


func peer_connected(game_client_id):
	print ("peer connected! player_id: ", game_client_id)


func peer_disconnected(game_client_id):
	print ("peer disconnected! player_id: ", game_client_id)

# this is called from GameClient
@rpc(any_peer)
func LoginRequest(username: String, password: String):
	var game_client_id = custom_multiplayer.get_remote_sender_id()
	#AuthenticationServer.AuthenticatePlayer(username, password, game_client_id)
	DoResponse(game_client_id)

func DoResponse(game_client_id):
	var result = true
	print ("GatewayServer ReturnLoginRequest... send ",result," to: ", game_client_id)
	rpc_id(game_client_id, "LoginRequestResponse", result, game_client_id) # func on client 
	#network.get_peer(game_client_id).peer_disconnect()

# this function is implemented on client
@rpc(any_peer)
func LoginRequestResponse(_result: bool, _game_client_id: int):
	pass

