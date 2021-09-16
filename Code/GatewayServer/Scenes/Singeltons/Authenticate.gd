extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 2021

func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect to authentication server.")
	
func _OnConnectionSucceeded():
	print("Successfully connected to autentication server.")
	
func AuthenticatePlayer(username, password, player_id):
	print("Sending out authentication request.")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)
	
remote func AuthenticationResults(result, player_id):
	print("Results recieved and replying to player login request.")
	Gateway.ReturnLoginRequest(result, player_id)
