extends Node

# GatewayServer on GameClient project
#note: this is a singleton!
#
# GatewayServer is only active upon a login request, which
# calls ConnectToServer()

var gateway_network : ENetMultiplayerPeer
var gateway_api : MultiplayerAPI
var ip := "127.0.0.1"
var port := 1910

# these should have data only between GatewayServer connect and auth response:
var username : String
var password : String


func _ready():
	pass


func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_multiplayer_peer():
		return
	custom_multiplayer.poll()


# this is called when login button pressed, on singleton in client
func ConnectToServer():
	gateway_network = ENetMultiplayerPeer.new()
	gateway_api = MultiplayerAPI.new()
	
	gateway_network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_path("/root/GatewayServer")
	custom_multiplayer.set_multiplayer_peer(gateway_network)
	
	gateway_network.connection_failed.connect(connection_failed)
	gateway_network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("Client connection to gateway failed!")
	print ("TODO: popup server fail")
	#TODO disable login button


func connection_succeeded():
	DoStuff()
	
func DoStuff():
	rpc_id(1, "LoginRequest", "kyle", "1234")


#this function is run on GatewayServer:
@rpc(any_peer) func LoginRequest(username: String, password: String): pass


@rpc(any_peer)
func LoginRequestResponse(result: bool, game_client_id: int):
	print ("Auth result for ", game_client_id, ": ", result)
	if result == true:
		print ("Login success!")
	else:
		print ("Incorrect login information")

	gateway_network.connection_failed.disconnect(connection_failed)
	gateway_network.connection_succeeded.disconnect(connection_succeeded)



#@rpc(any_peer)
#func ReturnLoginRequest(_result: bool, _game_client_id: int):
#	pass
