extends Node

# GameServer on GameServer project
#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var port := 1909
var max_players := 100

@onready var player_verification_process := get_node("PlayerVerification")


func _ready():
	StartServer()

#func _process(_delta):
#	if not custom_multiplayer.has_multiplayer_peer():
#		return
#	custom_multiplayer.poll()


func StartServer():
	network.create_server(port, max_players)
	multiplayer.set_multiplayer_peer(network)
	print ("GameServer started!")
	
	network.peer_connected.connect(peer_connected)
	network.peer_disconnected.connect(peer_disconnected)


func peer_connected(game_client_id):
	print ("GameServer: client connected! ", game_client_id)
	player_verification_process.Start(game_client_id)


func peer_disconnected(game_client_id: int):
	print ("GameServer: client disconnected! "+ game_client_id)
	#todo: probably need to store any unsaved data on the client's node
	get_node(str(game_client_id)).queue_free()


## This is called by any GameClient.
# requestor is an id internal to GameClient.
@rpc(any_peer)
func PlayerDataRequest(what:String, requestor:int):
	var game_client_id = multiplayer.get_remote_sender_id()
	
	# ...RETRIEVE DATA...
	print_debug("TODO: implement retrieve player data")
	var data = "STUFF"
	
	# send data back to client
	rpc_id(game_client_id, "PlayerDataResponse", what, data, requestor)


# this is implemented on GameClient
@rpc func PlayerDataResponse(_what:String, _data, _requestor:int): pass

