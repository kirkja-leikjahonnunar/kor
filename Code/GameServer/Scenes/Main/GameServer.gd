extends Node
class_name GameServer


# GameServer on GameServer project
#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var port := 1909
var max_players := 100

var expected_tokens := ["aaoeuauaoueoa"]


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
	await get_tree().process_frame
	player_verification_process.Start(game_client_id)


func peer_disconnected(game_client_id: int):
	print ("GameServer: client disconnected! ", game_client_id)
	#todo: probably need to store any unsaved data on the client's node
	if has_node(str(game_client_id)):
		get_node(str(game_client_id)).queue_free()


#-------------- Testing random data retrieval -----------------

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
func FetchPlayerToken(game_client_id):
	print ("Trying to call gameClient with PlayerTokenRequest, client id: ", game_client_id)
	print("GameServer currently has peers: ", multiplayer.get_peers())
	rpc_id(game_client_id, "PlayerTokenRequest") # RPC to GameClient.

# this is implemented on GameClient
@rpc func PlayerTokenRequest(): pass

# this is called from GameClient
@rpc(any_peer)
func PlayerTokenResponse(token: String):
	var game_client_id = multiplayer.get_remote_sender_id()
	print ("received token from game client: ", game_client_id)
	print ("  client token: ", token)
	player_verification_process.Verify(game_client_id, token)


## Called from GameClient.
#@rpc(any_peer)
#func Validate(client_token):
#	var game_client_id = get_tree().get_rpc_sender_id()
#	player_verification_process.Verify(game_client_id, client_token)


# Called from PlayerVerification.Verify().
func VerificationResponse(game_client_id, is_authorized: bool):
	rpc_id(game_client_id, "VerificationResponseToClient", is_authorized)

# this is implemented on GameClient
@rpc func VerificationResponseToClient(_is_authorized): pass


#------------------------------------------------------------------------------
# Invalidate player tokens after 30 seconds.
#------------------------------------------------------------------------------

func _on_TokenExpiration_timeout():
	var current_time = Time.get_unix_time_from_system()
	var token_time
	
	if expected_tokens.size() == 0:
		pass
	else:
		for i in range(expected_tokens.size() -1, -1, -1):
			print ("Checking token: ", expected_tokens[i])
			#print ("  right(64): ", expected_tokens[i].right(64))
			#print ("  right(-64): ", expected_tokens[i].right(-64))
			token_time = expected_tokens[i].right(-64).to_int()
			if current_time - token_time >= 31:
				expected_tokens.remove_at(i)
				print("REMOVED expected_token: " + str(i))
	
	print("Expected Tokens:")
	print(expected_tokens)

