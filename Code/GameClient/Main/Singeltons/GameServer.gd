#------------------------------------------------------------------------------
# Interface to the Game Server
#------------------------------------------------------------------------------
extends Node

var network = NetworkedMultiplayerENet.new()
#var ip = "127.0.0.1"
#var ip = "73.67.218.85"
var port = 1909

# Used to store tokens for comparison with the Authentication token from the player.
var gateway_token

	
func ConnectToGameServer(game_server_ip, game_server_port):
	network.create_client(game_server_ip, game_server_port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	#rpc_id(1, "NC_RequestPlayerAdd", "unblinky")
	print("Succesfully connected to GameServer")
	

#==============================================================================
# PLAYER VALIDATION FUNCTIONS	
#==============================================================================

# Called from GameServer.gd.
remote func FetchPlayerToken():
	rpc_id(1, "Validate", gateway_token) # RPC to GameServer.


remote func RequestGatewayToken():
	rpc_id(1, "RequestGatewayToken", gateway_token) # RPC to GameServer.


#------------------------------------------------------------------------------
# Called from GameServer.VerificationResponse().
#------------------------------------------------------------------------------
remote func VerificationResponse(is_authorized: bool):
	if is_authorized == true:
		get_node("../GameClient/LoginScreen").queue_free()
		print("Successful token verification.")
	else:
		var login = get_node("../GameClient/LoginScreen")
		login.login_button.disabled = false
		login.Opine("Login failed, please try again.")
		print("Login failed, please try again.")
	
#==============================================================================
# PLAYER DICTIONARY FUNCTIONS
#==============================================================================
func RequestPlayerDictionary():
	# TODO: rpc_id(1, "RequestPlayerDictionary")
	return ["hello", "11", "peter"]

remote func UpdatePlayerDictionary(data_table: Array):
	var dictionary = get_node("../GameClient/NetClicker/NoFrills")
	dictionary.Update(data_table)
	
#==============================================================================
# NET CLICKER FUNCTIONS
#==============================================================================
# Outbound.
func NC_RequestBootUp(playground_name: String):
	rpc_id(1, "NC_RequestBootUp", playground_name)
	
func NC_RequestUpdate():
	rpc_id(1, "NC_RequestUpdate")
	
func NC_UpdatePlayerClicks(player_db_id: int):
	rpc_id(1, "NC_UpdatePlayerClicks", player_db_id)

# All Forks Day.
func NC_UpdateForksGiven(player_db_id: int, delta_score: int):
	rpc_id(1, "NC_UpdateForksGiven", player_db_id, delta_score)


#------------------------------------------------------------------------------
# Unreliable messages.
# data: A full DB table of the players.
# TODO: Code Dup!!!
#------------------------------------------------------------------------------
# Inbound.
remote func NC_BootUpPlayground(data_table: Array, playground_name: String):
	var playground = get_node("../GameClient/NetClicker/" + playground_name)
	playground.BootUpPlayground(data_table)

remote func NC_UpdatePlayground(data_table: Array):
	var no_frills = get_node("../GameClient/NetClicker/NoFrills")
	no_frills.UpdatePlayground(data_table)
	
remote func NC_UpdateNetPlayer(data_table: Array):
	var forksgiving = get_node("../GameClient/NetClicker/Forksgiving")
	forksgiving.UpdatePlayground(data_table)
	
	
