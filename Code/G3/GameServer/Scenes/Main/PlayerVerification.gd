extends Node

onready var game_server = get_parent()
onready var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")

# Waiting room for connected peers:
# if the token takes a while to get to the server.
var awaiting_verification = {} 


func Start(player_id):
	awaiting_verification[player_id] = {"Timestamp": OS.get_unix_time()}
	game_server.FetchPlayerToken(player_id)
	print(awaiting_verification + "________________")


#------------------------------------------------------------------------------
# Verify the player_token a GameClient submits against tokens recieved
# from the Authentication server.
#------------------------------------------------------------------------------
func Verify(player_id, player_token):
	var is_authorized: bool = false
	
	# Try to verify for 30 seconds.
	while OS.get_unix_time() - int(player_token.right(64)) <= 30:
		
		# Grant access to the player, unless the internet broke.
		if game_server.expected_tokens.has(player_token):
			is_authorized = true
			#CreatePlayerContainer(player_id)
			awaiting_verification.erase(player_id)
			game_server.expected_tokens.erase(player_token)
			break
		else:
			# Wait 2 seconds before, trying again (provides 15 attempts).
			yield(get_tree().create_timer(2), "timeout")
	
	game_server.VerificationResponse(player_id, is_authorized)
	
	# Make sure people are disconnected.
	# Could be dodgy behaviour, or an internet hickup.
	if is_authorized == false:
		awaiting_verification.erase(player_id)
		game_server.network.disconnect_peer(player_id)


func CreatePlayerContainer(player_id):
	var new_player_container = player_container_scene.instance()
	new_player_container.name = str(player_id)
	get_parent().add_child(new_player_container, true) # True = When you add to the scene node will human readable guarentee.
	var player_container = get_node("../" + str(player_id))
	FillPlayerContariner(player_container)


func FillPlayerContariner(player_container):
	player_container.player_stats = ServerData.stats_data


#------------------------------------------------------------------------------
# In case the token has -10,000 years on our server.
#------------------------------------------------------------------------------
func _on_VerificationExpiration_timeout():
	var current_time = OS.get_unix_time()
	var start_time
	
	if awaiting_verification == {}:
		pass
	else: # key is the player_id too.
		for key in awaiting_verification.keys():
			start_time = awaiting_verification[key].Timestamp
			if current_time - start_time >= 10:
				awaiting_verification.erase(key)
				var connected_peers = Array(get_tree().get_network_connected_peers())
				
				# If the peer still exists on the network, boot 'em if disconnection.
				if connected_peers.has(key):
					game_server.ReturnTokenVerificationResults(key, false)
					game_server.network.disconnect_peer(key)
					
	print("Awaiting verification:")
	print(awaiting_verification)
				
