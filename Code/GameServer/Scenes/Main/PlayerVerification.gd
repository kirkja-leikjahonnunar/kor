extends Node
class_name PlayerVerification


@onready var game_server = get_parent()
@onready var player_container_scene := preload("res://Scenes/Instances/PlayerContainer.tscn")


# Waiting room for connected peers:
# if the token takes a while to get to the server.
var awaiting_verification = {} 


func Start(player_id):
	awaiting_verification[player_id] = {"Timestamp": OS.get_unix_time()}
	game_server.FetchPlayerToken(player_id)
	print(awaiting_verification + "________________")


func CreatePlayerContainer(game_client_id):
	var new_player_container = player_container_scene.instantiate()
	new_player_container.name = str(game_client_id)
	get_parent().add_child(new_player_container, true)
	#var player_container = get_node("../" + str(game_client_id))
	#FillPlayerContainer(player_container)
	FillPlayerContainer(new_player_container)

func FillPlayerContainer(_player_container):
	#player_container.player_stats = ServerData.test_data.Stats
	pass


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
			await get_tree().create_timer(2).timeout
	
	game_server.VerificationResponse(player_id, is_authorized)
	
	# Make sure people are disconnected.
	# Could be dodgy behaviour, or an internet hickup.
	if is_authorized == false:
		awaiting_verification.erase(player_id)
		game_server.network.disconnect_peer(player_id)
