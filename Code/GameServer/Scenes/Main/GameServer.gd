extends Node

# GameServer on GameServer project
#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var port := 1909
var max_players := 100


func _ready():
	StartServer()

#func _process(_delta):
#	if not custom_multiplayer.has_multiplayer_peer():
#		return
#	custom_multiplayer.poll()


func StartServer():
	network.create_server(port, max_players)
	#set_custom_multiplayer(gateway_api)
	#custom_multiplayer.set_root_node(self) TODO: IS THIS NECESSARY?
	#custom_multiplayer.set_root_path("/GatewayServer")
	#custom_multiplayer.set_multiplayer_peer(network)
	print ("GameServer started!")
	
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)


func peer_connected(player_id):
	print ("GameServer peer connected! ", player_id)


func peer_disconnected(player_id):
	print ("GameServer peer disconnected! ", player_id)


#@rpc(any_peer)
#func LoginRequest(username: String, password: String):
#	print("LoginRequest on GatewayServer")
#
#	var player_id = custom_multiplayer.get_remote_sender_id()
#	AuthenticationServer.AuthenticatePlayer(username, password, player_id)
#	#rpc_id(1, "RequestPlayerData", what, requestor)
#
#@rpc
#func ReturnLoginRequest(result, player_id):
#	rpc_id(player_id, "ReturnLoginRequest", result)
#	network.get_peer(player_id).peer_disconnect()


## this is a stub, the true function is on the real server
#@rpc(any_peer) func RequestPlayerData(what:String, requestor:int): pass
#
#
#@rpc(any_peer)
#func PlayerDataResponse(what:String, requestor:int):
#	print("client received response: ", what, ", requestor: ", requestor)
#	#instance_from_id(requestor).dealwithit

