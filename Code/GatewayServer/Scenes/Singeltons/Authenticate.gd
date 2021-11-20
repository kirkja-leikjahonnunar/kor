#==============================================================================
# Interface to the Authentication server.
#------------------------------------------------------------------------------
extends Node

var network = NetworkedMultiplayerENet.new()
#var auth_ip = "127.0.0.1"
#var ip = "10.0.10.101"
var port = 1911


func ConnectToServer(auth_ip):
	network.create_client(auth_ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect to authentication server.")
	
func _OnConnectionSucceeded():
	print("Successfully connected to autentication server.")
	
	
# Called from Gateway.
func LoginRequest(username, password, player_id):
	rpc_id(1, "LoginRequest", username, password, player_id) # RPC to Authenticate.
	print("Requesting authentication.")
	
# Called from Gateway UI button click.
func PingRequest():
	rpc_id(1, "PingRequest") # RPC request to Authentication server.
	print("Ping Request pending...")
	

# Called from AuthenticationServer.ValidateLogin()
remote func AuthorizationResponse(result, player_id, authentication_token):
	Gateway.AuthorizationResponse(result, player_id, authentication_token)
	print("Results recieved and replying to player login request.")
	
remote func PingResponse(message: String):
	print(message)
