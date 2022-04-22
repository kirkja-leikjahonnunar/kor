extends Node

var network := ENetMultiplayerPeer.new()
var port := 1911
var max_servers := 5


func _ready():
	start_server()


func start_server():
	network.create_server(port, max_servers)
	
	#get_tree().set_network_peer(network)
	multiplayer.set_multiplayer_peer(network)
	
	print ("Authentication Server started!")
	
	#network.connect("peer_connected", peer_connected, [])
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)
	
	#print("peer id: "+network.)


func peer_connected(gateway_id):
	print ("Gateway " + str(gateway_id) + " Connected!")


func peer_disconnected(gateway_id):
	print ("Gateway " + str(gateway_id) + " Disconnected!")


@rpc(any_peer)
func AuthenticatePlayer(username:String, password:String, game_client_id):
	print("AuthenticatePlayer on AuthenticationServer: ", username, ": ", password)
	var gateway_id = multiplayer.get_remote_sender_id()
	var result

	if not PlayerData.HasPlayer(username):
		print ("Unknown user ", username)
		result = false
	elif not PlayerData.UserPassword(username) == password:
		print ("Incorrect password!")
		result = false
	else:
		print ("Successful authentication for ", username)
		result = true
	
	print("sending auth response for "+username, ", result: ", result)
	rpc_id(gateway_id, "AuthenticationResults", result, game_client_id)


# these are stubs, the real functions are on client side
#@rpc(any_peer) func PlayerDataResponse(what:String, requestor:int): pass
@rpc(any_peer) func AuthenticationResults(_result, _player_id): pass #sends to GatewayServer


#---------------- Ping test ----------------------------

# for debugging rpc calls..

@rpc(any_peer)
func PingAuthenticateServer():
	var gateway_id = multiplayer.get_remote_sender_id()
	print ("Sending ping response to gateway: ", gateway_id)
	rpc_id(gateway_id, "AuthPingResponse")
@rpc func AuthPingResponse(): pass

