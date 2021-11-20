# Main class for this Gatway project.
extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1910
var max_players = 100
var cert = load("res://Certificate/X509Certificate.crt")
var key = load("res://Certificate/X509Key.key")


func _ready():
	StartServer()


func _process(_delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()


func StartServer():
	# Certificate stuff.
	network.set_dtls_enabled(true)
	network.set_dtls_key(key)
	network.set_dtls_certificate(cert)
	
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self) # Becomes available.
	custom_multiplayer.set_network_peer(network)
	print("Gateway server started.")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	
func _Peer_Connected(player_id):
	print("User Connected ID: " + str(player_id))

func _Peer_Disconnected(player_id: int):
	print("User Disconnected ID: " + str(player_id))


#==============================================================================
# LOGIN AND AUTHORIZATION
#==============================================================================
remote func GatewayLoginRequest(username: String, password: String):
	print("Gateway > remote IncomingLoginRequest(%s, %s)" % [username, password])
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.LoginRequest(username, password, player_id)
	
	
func AuthorizationResponse(result: bool, player_id: int, token):
	rpc_id(player_id, "AuthorizationResponse", result, token)
	network.disconnect_peer(player_id)
	print("Gateway > func AuthorizationResponse()")
