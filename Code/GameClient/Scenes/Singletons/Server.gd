extends Node

#note: this is a singleton!

var network := ENetMultiplayerPeer.new()
var ip := "127.0.0.1"
var port := 1909


func _ready():
	ConnectToServer()


func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
	network.connection_failed.connect(connection_failed)
	network.connection_succeeded.connect(connection_succeeded)


func connection_failed():
	print ("Connection failed!")


func connection_succeeded():
	print ("Connection succeeded!")
