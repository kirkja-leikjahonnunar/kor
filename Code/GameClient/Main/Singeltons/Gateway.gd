extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var gateway_ip: String
var gateway_port: int
var cert = load("res://Main/Certificate/X509Certificate.crt") # Use load().

var username
var password

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func ConnectToGatewayServer(my_username: String, my_password: String, my_gateway_ip: String, my_gateway_port: int):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	# Dissable global DB search for self signed cert.
	network.set_dtls_enabled(true)
	network.set_dtls_verify_enabled(false) # Set to true on release with a 3rd party signed cert.
	network.set_dtls_certificate(cert)
	
	username = my_username
	password = my_password
	gateway_ip = my_gateway_ip
	gateway_port = my_gateway_port
	network.create_client(gateway_ip, gateway_port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
	
func _OnConnectionFailed():
	print("Failed to connect to login server.")
	get_node("../Main/LoginScreen/Button").disabled = false
	
	
func _OnConnectionSucceeded():
	print("Succesfully connected to Gateway server.")
	RequestGatewayLogin()
	
	
func RequestGatewayLogin():
	rpc_id(1, "GatewayLoginRequest", username, password) # RPC to Gateway.
	print("RPC to Gateway.")
	#username = ""
	password = ""
	
	
remote func AuthorizationResponse(result: bool, gateway_token):
	print("Results recieved.")
	
	if result == true:
		
		# Send the token we got from the Gateway server.
		GameServer.gateway_token = gateway_token
		GameServer.ConnectToGameServer(gateway_ip, gateway_port)
		#get_node("../GameClient/LoginScreen").queue_free()
	else:
		#get_node("../GameClient/LoginScreen/Button").disabled = false
		print("Please provide correct username and password.")
		
	network.disconnect("connection_failed", self, "_OnConnectionFailed")
	network.disconnect("connection_succeeded", self, "_OnConnectionSucceeded")
