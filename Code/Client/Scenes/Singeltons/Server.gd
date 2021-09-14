# Game Development Center - https://youtu.be/lnFN6YabFKg
# The Server singelton.
# The client makes connections through this static class.
extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 2021

#------------------------------------------------------------------------------
# Ready to roll
#------------------------------------------------------------------------------
func _ready():
	ConnectToServer()

#------------------------------------------------------------------------------
# Create a client for the network and connect the listener functions.
#------------------------------------------------------------------------------
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "OnConnectionFailed")
	network.connect("connection_succeeded", self, "OnConnectionSucceeded")

#------------------------------------------------------------------------------
# Connection failed.
#------------------------------------------------------------------------------
func OnConnectionFailed():
	print("Failed to connect.")

#------------------------------------------------------------------------------
# Connection succeeded.
#------------------------------------------------------------------------------
func OnConnectionSucceeded():
	print("Succesfuly connected.")
	

#------------------------------------------------------------------------------
# Get the password from the server.
#------------------------------------------------------------------------------
func FetchPlayerPassword(username, requester):
	# 0 = everyone, 1 = server, otherwise a specific peer id we want to call.
	rpc_id(1, "FetchPlayerPassword", username, requester) # Server request.

#------------------------------------------------------------------------------
# RPC for Server to connect with.
#------------------------------------------------------------------------------
remote func ReturnPlayerPassword(s_password, requester):
	instance_from_id(requester).PrinPass(s_password)
