extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100


var expected_tokens = ["91b20b2cb97add3a4064912117681ea6c5efeb23fe2179b6d88aed3bb071ef891633426935",
					   "91b20b2cb97add3a4064912117681ea6c5efeb23fe2179b6d88aed3bb071ef891633327824",
					   "91b20b2cb97add3a4064912117681ea6c5efeb23fe2179b6d88aed3bb071ef891633226935"]

onready var player_verification_process = $PlayerVerification


func _ready():
	print(expected_tokens)
	StartServer()
	
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("GameServer started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	
func _Peer_Connected(player_id):
	player_verification_process.Start(player_id)
	print("User: " + str(player_id) + " Connected")
	
	
func _Peer_Disconnected(player_id):
	get_node(str(player_id)).queue_free()
	print("User: " + str(player_id) + " Disconnected")


#------------------------------------------------------------------------------
# Player Verification
#------------------------------------------------------------------------------
# Called from "PlayerVerification.gd".
func FetchPlayerToken(player_id):
	rpc_id(player_id, "FetchPlayerToken") # RPC to GameClient.
	

# Called from GameClient
remote func Validate(client_token):
	var player_id = get_tree().get_rpc_sender_id()
	player_verification_process.Verify(player_id, client_token)


# Called from PlayerVerification.Verify().
func VerificationResponse(player_id, is_authorized: bool):
	rpc_id(player_id, "VerificationResponse", is_authorized)


#------------------------------------------------------------------------------
# Invalidate player tokens after 30 seconds.
#------------------------------------------------------------------------------
func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	
	if expected_tokens == []:
		pass
	else:
		for i in range(expected_tokens.size() -1, -1, -1):
			token_time = int(expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.remove(i)
				print("REMOVED: " + str(i))
				
	print("Expected Tokens:")
	print(expected_tokens)


#==============================================================================
# NET CLICKER FUNCTIONS
# TODO: Super code duplication!!!!
# Kidding!!!
#==============================================================================
remote func NC_RequestBootUp(playground_name: String):
	var player_id = get_tree().get_rpc_sender_id()
	var db_table: Array = ServerData.DB_GetAllPlayersData()
	# TODO: Look up only those on the playground.
	
	rpc_id(player_id, "NC_BootUpPlayground", db_table, playground_name)


remote func NC_RequestUpdate():
	var player_id = get_tree().get_rpc_sender_id()
	var db_table: Array = ServerData.DB_GetAllPlayersData()
	# TODO: Forward this to a more efficient DB later.
	# TODO: Look up only those on the playground.
	
	#rpc_id(player_id, "NC_UpdatePlayground", db_table)
	rpc_id(player_id, "NC_UpdateNetPlayer", db_table)
	
	print("%s: %s" % [db_table[0]["Name"], db_table[0]["Clicks"]])


remote func NC_UpdatePlayerClicks(player_db_id: int):
	ServerData.DB_UpdateClicks(player_db_id, 1) # TODO: Get player increment.
	
	var peer_id = get_tree().get_rpc_sender_id()
	var db_table: Array = ServerData.DB_GetAllPlayersData()
	rpc_id(peer_id, "NC_UpdatePlayground", db_table)
	
	#rpc_unreliable("NC_UpdatePlayers", all_players_data)


remote func NC_UpdateForksGiven(player_db_id: int, delta_score: int):
	ServerData.DB_UpdateClicks(player_db_id, 1) # TODO: Get player increment.
	
	var peer_id = get_tree().get_rpc_sender_id()
	var db_table: Array = ServerData.DB_GetAllPlayersData()
	rpc_id(peer_id, "NC_UpdateNetPlayer", db_table)
	
