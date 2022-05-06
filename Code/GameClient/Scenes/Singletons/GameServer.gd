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
	get_node("/root/Client/LoginScreen").visible = true
	get_node("/root/Client/DebugOverlay").UpdateClientId(-1)


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
		get_node("/root/Client/LoginScreen").visible = false
		get_node("/root/Client/DebugOverlay").UpdateClientId(multiplayer.get_unique_id())
		print ("We have lift off!")
	else:
		print ("Login failed, please try again!")
		get_node("/root/Client/LoginScreen").LoginRejectedFromGameServer()


#------------ Player Maintenance ----------------------

@rpc
func DespawnPlayer(game_client_id):
	print ("GameServer says to despawn: ", game_client_id)
	get_node("/root/Client/World").DespawnPlayer(game_client_id)

@rpc
func SpawnNewPlayer(game_client_id: int, spawn_point: Vector2):
	print ("GameServer says to spawn player ", game_client_id, " at ", spawn_point)
	get_node("/root/Client/World").SpawnNewPlayer(game_client_id, spawn_point)


#------------------ Syncing player state ------------------

func SendPlayerState(player_state):
	#print ("player state: ", player_state)
	rpc_id(1, "ReceivePlayerState", player_state)

# This is implemented on GameServer
@rpc(any_peer, unreliable)
func ReceivePlayerState(player_state): pass


# This is called from GameServer
@rpc(unreliable)
func ReceiveWorldState(world_state):
	#print ("Received world state: ", world_state)
	get_node("/root/Client/World").UpdateWorldState(world_state)



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

