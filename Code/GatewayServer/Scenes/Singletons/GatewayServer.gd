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
	custom_multiplayer.set_root_path("/root/GatewayServer")
	custom_multiplayer.set_multiplayer_peer(network)
	print ("Gateway server started!")
	
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)


func peer_connected(game_client_id):
	print ("Authenticate peer connected! player_id: ", game_client_id)


func peer_disconnected(game_client_id):
	print ("Authenticate peer disconnected! player_id: ", game_client_id)

# this is called from GameClient
@rpc(any_peer)
func LoginRequest(username: String, password: String):
	print("LoginRequest on GatewayServer with: ", username, ": ", password)
	
	var game_client_id = custom_multiplayer.get_remote_sender_id()
	print ("game_client_id (remote sender id) at LoginRequest: ", game_client_id)
	AuthenticationServer.AuthenticatePlayer(username, password, game_client_id)


# this local func is called after Auth server returns results
func ReturnLoginRequest(result: bool, game_client_id: int):
	print ("GatewayServer ReturnLoginRequest... send to: ", game_client_id)
	#rpc_id(game_client_id, "LoginRequestResponse", result, game_client_id) # func on client 
	#network.get_peer(game_client_id).peer_disconnect()

# this function is implemented on client
@rpc(any_peer)
func LoginRequestResponse(_result: bool, _game_client_id: int):
	pass

## this is a stub, the true function is on the real server
#@rpc(any_peer) func RequestPlayerData(what:String, requestor:int): pass
#
#
#@rpc(any_peer)
#func PlayerDataResponse(what:String, requestor:int):
#	print("client received response: ", what, ", requestor: ", requestor)
#	#instance_from_id(requestor).dealwithit

