extends Node

# GameServer on GameClient
#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1909


func _ready():
	pass
	#ConnectToServer()


func ConnectToServer():
	print ("Attempting to connect to game server...")
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
	network.connection_failed.connect(connection_failed)
	network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("GameServer Connection failed!")


func connection_succeeded():
	print ("GameServer Connection succeeded!")
	#RequestPlayerDataLocal()
	RequestPlayerDataLocal("thing", get_instance_id())



#@rpc(any_peer)
#func PlayerDataResponse(returned, requestor):
#	print("client received response: "+returned)
#	#instance_from_id(requestor).dealwithit


func RequestPlayerDataLocal(what: String, requestor: int):
	print("RequestPlayerData on client")
	
	rpc_id(1, "RequestPlayerData", what, requestor)


## this is a stub, the true function is on the real server
#@rpc(any_peer) func RequestPlayerData(_what:String, _requestor:int): pass
#
#
#@rpc(any_peer)
#func PlayerDataResponse(what:String, requestor:int):
#	print("client received response: ", what, ", requestor: ", requestor)
#	#instance_from_id(requestor).dealwithit
#
