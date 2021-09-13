# Game Development Center - https://youtu.be/lnFN6YabFKg
extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 2021

func _ready():
	ConnectToServer()
	
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "OnConnectionFailed")
	network.connect("connection_succeeded", self, "OnConnectionSucceeded")
	
func OnConnectionFailed():
	print("Failed to connect.")
	
func OnConnectionSucceeded():
	print("Succesfuly connected.")
