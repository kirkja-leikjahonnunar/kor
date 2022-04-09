extends Node

var network := ENetMultiplayerPeer.new()
var port := 1909
var max_players := 100


func _ready():
	start_server()
	


func start_server():
	network.create_server(port, max_players)
	
	#get_tree().set_network_peer(network)
	multiplayer.set_multiplayer_peer(network)
	
	print ("Server started!")
	
	#network.connect("peer_connected", peer_connected, [])
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)
	
	#print("peer id: "+network.)


func peer_connected(player_id):
	print ("User " + str(player_id) + " Connected!")


func peer_disconnected(player_id):
	print ("User " + str(player_id) + " Disconnected!")


@rpc(any_peer)
func RequestPlayerData(what:String, requestor:int):
	var player_id = multiplayer.get_remote_sender_id()
	print("RequestPlayerData: ", what, ": ", requestor)

	print("sending response for "+what)
	rpc_id(player_id, "PlayerDataResponse", what+"-booyah", requestor)


# this is a stub, the real function is on client side
@rpc(any_peer) func PlayerDataResponse(what:String, requestor:int): pass

