extends Node

var gateway_network : ENetMultiplayerPeer
var gateway_api : MultiplayerAPI
var max_servers = 50
var port := 1912

var gameserverlist := {}

func _ready():
	StartServer()

func _process(_delta: float):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_multiplayer_peer():
		return
	custom_multiplayer.poll()


func StartServer():
	gateway_network = ENetMultiplayerPeer.new()
	gateway_api = MultiplayerAPI.new()
	
	gateway_network.create_server(port, max_servers)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_path("/root/GameServers")
	custom_multiplayer.set_multiplayer_peer(gateway_network)
	print ("GameServer hub started!")
	
	gateway_network.peer_connected.connect(peer_connected)
	gateway_network.peer_disconnected.connect(peer_disconnected)


func peer_connected(gateway_id):
	print ("GameServer connected to GameServers hub: ", gateway_id)
	gameserverlist["GameServer"+str(gameserverlist.size()+1)] = gateway_id

func peer_disconnected(gateway_id):
	print ("GameServer disconnected to GameServers hub: ", gateway_id)


func DistributeLoginToken(token, gameserver):
	pass

