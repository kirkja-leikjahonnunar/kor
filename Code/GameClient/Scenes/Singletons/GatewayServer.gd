extends Node

#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var gateway_api := MultiplayerAPI.new()
var ip := "127.0.0.1"
var port := 1910

var username : String
var password : String


func _ready():
	pass


func _process(delta):
	if get_custom_multiplayer() != null:
		return
	if not custom_multiplayer.has_multiplayer_peer():
		return
	custom_multiplayer.poll()


# this is called when login button pressed
func ConnectToServer(_username, _password):
	network = ENetMultiplayerPeer.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connection_failed.connect(connection_failed)
	network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("Client connection to gateway failed!")
	print ("TODO: popup server fail")
	#TODO disable login button


func connection_succeeded():
	print ("Client connection to gateway succeeded!")
	RequestLogin()

func RequestLogin():
	print ("Connecting to Gateway Server to request login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""


@rpc
func ReturnLoginRequest(result, player_id):
	print ("Auth result for ", player_id, ": ", result)
	if result == true:
		GameServer.ConnectToServer()
		# free login screen
	else:
		print ("Incorrect login information")
		#.. enable login button
	
	network.connection_failed.disconnect(connection_failed)
	network.connection_succeeded.disconnect(connection_succeeded)


#this function is run on server:
@rpc func LoginRequest(username: String, password: String): pass


