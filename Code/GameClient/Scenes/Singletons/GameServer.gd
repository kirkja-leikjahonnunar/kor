extends Node

# GameServer on GameClient
#note: this is a singleton!

var game_server_network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1909

var token : String # this gets generated originally by the auth server


func _ready():
	pass


func ConnectToServer():
	print ("Attempting to connect to game server...")
	game_server_network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(game_server_network)
	
	game_server_network.connection_failed.connect(connection_failed)
	game_server_network.connection_succeeded.connect(connection_succeeded)
	game_server_network.server_disconnected.connect(server_disconnected)


func connection_failed():
	print ("GameServer Connection failed!")
	game_server_network.connection_failed.disconnect(connection_failed)
	game_server_network.connection_succeeded.disconnect(connection_succeeded)

func connection_succeeded():
	print ("GameServer Connection succeeded! client id: ", multiplayer.get_unique_id())
	#RequestPlayerData("test", get_instance_id())

func server_disconnected():
	print ("GameServer disconnected!")
	


# this is called from a GameServer
@rpc
func PlayerTokenRequest():
	print ("Got PlayerTokenRequest from GameServer, sending response")
	rpc_id(1, "PlayerTokenResponse", token)

# this is implemented on GameServer
@rpc(any_peer) func PlayerTokenResponse(_token: String): pass


# this is called from GameServer
@rpc
func VerificationResponseToClient(is_authorized):
	print ("GameServer says authorized: ", is_authorized)
	if is_authorized:
		#TODO: remove login screen
		pass
	else:
		print ("Login failed, please try again!")
		#TODO: reenable login button



##------------------------ Testing ---------------------------
func RequestPlayerData(what: String, requestor: int):
	print("RequestPlayerData on client: ", what)
	
	rpc_id(1, "PlayerDataRequest", what, requestor)

## this is a stub, the true function is on the GameServer
@rpc(any_peer) func PlayerDataRequest(_what:String, _requestor:int): pass


# this is called by the GameServer
@rpc
func PlayerDataResponse(what:String, data, requestor:int):
	print("client received response: ", what, ", data: ", data, ", requestor: ", requestor)
	instance_from_id(requestor).DataReceived(what, data)

# FOR TESTING ONLY!
func DataReceived(what, data):
	print ("Data receieved at object: ", what, ": ", data)

