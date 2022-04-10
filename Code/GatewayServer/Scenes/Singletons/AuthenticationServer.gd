extends Node

#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1911


func _ready():
	ConnectToServer()


func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
	network.connection_failed.connect(connection_failed)
	network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("Authenticate Connection failed!")


func connection_succeeded():
	print ("Authenticate Connection succeeded!")
	#RequestPlayerDataLocal("thing", get_instance_id())


@rpc
func AuthenticatePlayer(username: String, password: String, player_id):
	print("AuthenticatePlayer on GatewayServer")
	
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)

@rpc
func AuthenticationResults(result, player_id):
	print("Auth result: ", result, " for ", player_id)
	GatewayServer.ReturnLoginRequest(result, player_id)



## this is a stub, the true function is on the real server
#@rpc(any_peer) func RequestPlayerData(what:String, requestor:int): pass
#
#
#@rpc(any_peer)
#func PlayerDataResponse(what:String, requestor:int):
#	print("client received response: ", what, ", requestor: ", requestor)
#	#instance_from_id(requestor).dealwithit

