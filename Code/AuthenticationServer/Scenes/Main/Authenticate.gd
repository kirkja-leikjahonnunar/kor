extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1911
var max_game_servers = 5


func _ready():
	StartServer()
	var token = str(randi()).sha256_text() + str(OS.get_unix_time())
	print(token)


func StartServer():
	network.create_server(port, max_game_servers)
	get_tree().set_network_peer(network)
	print("Authentication server started.")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	
func _Peer_Connected(gateway_id):
	print("Gateway " + str(gateway_id) + " connected.")
	
	
func _Peer_Disconnected(gateway_id):
	print("Gateway " + str(gateway_id) + " disconnected.")
	
	
#------------------------------------------------------------------------------
# Called from Gateway.Authenticate.LoginRequest()
#------------------------------------------------------------------------------
remote func LoginRequest(username: String, password: String, player_id: int) -> void:
	print("Login request recieved.")
	
	var authorization_token
	var gateway_id: int = get_tree().get_rpc_sender_id()
	var result: bool = false
	print("Starting authentication.")
	
	
#	if not PlayerData.player_data.has(username):
#		print("User not recognized.")
#	elif not PlayerData.player_data[username].password == password:
#		print("Incorrect password.")

	var vital_data: Array = PlayerData.DB_QueryVitals(username)
	print("Ho Ho HO:" + str(vital_data))
	
	if vital_data == null:
		print("User %s not recognized." % username)
	elif vital_data[0]["password"] != password:
		print("Incorrect password.")
	else:
		result = true
		print("Successful authentication.")
		
		
		randomize()
		authorization_token = str(randi()).sha256_text() + str(OS.get_unix_time())
		print("Token: %s" % authorization_token)
		
		var game_server = "GameServer1" # TODO: Replace with loadbalance.
		GameServers.DistributeAuthenticationToken(authorization_token, game_server)
		
	# Respond to the Gateway.
	rpc_id(gateway_id, "AuthorizationResponse", result, player_id, authorization_token)
	print("Result: %s (authentication results sent to Gateway server)" % result)


remote func PingRequest():
	var caller_id = get_tree().get_rpc_sender_id()
	rpc_id(caller_id, "PingResponse", "I see you %s!" % caller_id)
	print("Gateway %s pinged us." % caller_id)
