extends Node

# HubConnection
# note: this is a singleton


var hub_network : ENetMultiplayerPeer
var hub_api : MultiplayerAPI
var ip := "127.0.0.1"
var port := 1912

@onready var gameserver : GameServer = get_node("/root/GameServer")


func _ready():
	ConnectToServer()


func _process(_delta: float):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_multiplayer_peer():
		return
	custom_multiplayer.poll()


func ConnectToServer():
	print("HubConnection.ConnectToServer called")
	
	hub_network = ENetMultiplayerPeer.new()
	hub_api = MultiplayerAPI.new()
	
	hub_network.create_client(ip, port)
	set_custom_multiplayer(hub_api)
	custom_multiplayer.set_root_path("/root/HubConnection")
	custom_multiplayer.set_multiplayer_peer(hub_network)
	
	hub_network.connection_failed.connect(connection_failed)
	hub_network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("GameServer connection to hub failed!")
	print ("TODO: popup server fail")
	#TODO disable login button

func connection_succeeded():
	print ("GameServer connection to hub succeeded!")


@rpc
func ReceiveLoginToken(token):
	gameserver.expected_tokens.append(token)

