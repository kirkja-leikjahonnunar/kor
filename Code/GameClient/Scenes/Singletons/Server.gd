extends Node

#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1909


func _ready():
	ConnectToServer()


func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
	network.connection_failed.connect(connection_failed)
	network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("Connection failed!")


func connection_succeeded():
	print ("Connection succeeded!")
	RequestPlayerDataLocal()
	#RequestPlayerData("thing", get_instance_id())


#@rpc
#func RequestPlayerData(what: String, requestor: int):
#	print("RequestPlayerData ",what," requestor: ", requestor)
#
#	rpc_id(1, "RequestPlayerData", what, requestor)
#
#
#@rpc(any_peer)
#func PlayerDataResponse(returned, requestor):
#	print("client received response: "+returned)
#	#instance_from_id(requestor).dealwithit


func RequestPlayerDataLocal():
	print("RequestPlayerData on client")
	
	rpc_id(1, "RequestPlayerData")


# this is a stub, the true function is on the real server
@rpc(any_peer)
func RequestPlayerData():
	pass


@rpc(any_peer)
func PlayerDataResponse():
	print("client received response: ")
	#instance_from_id(requestor).dealwithit


#@rpc(unreliable)
#func UpdateWhatever():
#	pass

