extends Node

# GameServer on GameServer project
#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var port := 1909
var max_players := 100

var expected_tokens := []


@onready var player_verification_process := get_node("PlayerVerification") as PlayerVerification


func _ready():
	StartServer()


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



#------------------------------------------------------------------------------
# Player Verification
#------------------------------------------------------------------------------
# Called from "PlayerVerification.gd".
func FetchPlayerToken(player_id):
	rpc_id(player_id, "FetchPlayerToken") # RPC to GameClient.



# Called from GameClient.
@rpc(any_peer)
func Validate(client_token):
	var game_client_id = get_tree().get_rpc_sender_id()
	player_verification_process.Verify(game_client_id, client_token)


# Called from PlayerVerification.Verify().
func VerificationResponse(game_client_id, is_authorized: bool):
	rpc_id(game_client_id, "VerificationResponse", is_authorized)


#------------------------------------------------------------------------------
# Invalidate player tokens after 30 seconds.
#------------------------------------------------------------------------------

func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	
	if expected_tokens.size() == 0:
		pass
	else:
		for i in range(expected_tokens.size() -1, -1, -1):
			token_time = int(expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.remove_at(i)
				print("REMOVED: " + str(i))
				
	print("Expected Tokens:")
	print(expected_tokens)


