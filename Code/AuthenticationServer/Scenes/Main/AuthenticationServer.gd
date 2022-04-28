extends Node

var network := ENetMultiplayerPeer.new()
var port := 1911
var max_servers := 5


func _ready():
	start_server()


func start_server():
	network.create_server(port, max_servers)
	
	multiplayer.set_multiplayer_peer(network)
	
	print ("Authentication Server started!")
	
	#network.connect("peer_connected", peer_connected, [])
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)
	
	#print("peer id: "+network.)

var gateway_id # we only have this global to test pinging
func peer_connected(new_gateway_id):
	print ("Gateway " + str(new_gateway_id) + " Connected!")
	gateway_id = new_gateway_id
	# ping for debugging, auth to gateway:
	#get_tree().create_timer(1.0).timeout.connect(DoPingGatewayServer)


func peer_disconnected(old_gateway_id):
	print ("Gateway " + str(old_gateway_id) + " Disconnected!")

var token

# called from GatewayServer
@rpc(any_peer)
func RequestAuthentication(username:String, password:String, game_client_id: int):
	print("AuthenticatePlayer on AuthenticationServer: ", username, ": ", password)
	var from_gateway_id = multiplayer.get_remote_sender_id()
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
		
		randomize()
		var random_number = randi()
		print(random_number)
		var hashed = str(random_number).sha256_text()
		print (hashed)
		var timestamp = str(Time.get_unix_time_from_system())
		print (timestamp)
		token = hashed + timestamp
		
		token = str(randi()).sha256_text() + str(Time.get_unix_time_from_system())
		print ("token generated: ", token)
		
		var gameserver = "GameServer1" #TODO: replace with proper load balance selection for server
		GameServers.DistributeLoginToken(token, gameserver)
	
	print("sending auth response for "+username, ", result: ", result)
	rpc_id(from_gateway_id, "AuthenticationResponse", result, game_client_id)


# these are stubs, the real functions are on client side
#@rpc(any_peer) func PlayerDataResponse(what:String, requestor:int): pass
@rpc(any_peer) func AuthenticationResponse(_result: bool, _player_id: int): pass #sends to GatewayServer




##---------------- Ping test ----------------------------
#
## for debugging rpc calls: gateway to auth..
#
#@rpc(any_peer)
#func PingAuthenticateServer():
#	var from_gateway_id = multiplayer.get_remote_sender_id()
#	print ("Sending ping response to gateway: ", from_gateway_id)
#	rpc_id(from_gateway_id, "AuthPingResponse")
#@rpc func AuthPingResponse(): pass
#
#
##----------------------- Ping test: auth ping gateway -------------------------
#var last_gateway_ping_time := 0
#var do_gateway_pings := false
#
## for debugging rpc calls..
#func DoPingGatewayServer():
#	do_gateway_pings = true
#	last_gateway_ping_time = Time.get_ticks_usec()
#	#var gateway_id = multiplayer.get_remote_sender_id()
#	print ("Trying to ping GatewayServer from auth server to gateway: ",gateway_id,"...")
#	rpc_id(gateway_id, "PingGatewayServer")
#
#@rpc func PingGatewayServer(): pass
#@rpc(any_peer) func GatewayPingResponse():
#	print ("Gateway server ping returned! elapsed time (ms): ", (Time.get_ticks_usec()-last_gateway_ping_time)/1000.0)
#	last_gateway_ping_time = 0
#	if do_gateway_pings:
#		#var gateway_id = multiplayer.get_remote_sender_id()
#		get_tree().create_timer(1.0).timeout.connect(DoPingGatewayServer)


