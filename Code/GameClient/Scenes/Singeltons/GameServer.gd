#------------------------------------------------------------------------------
# Interface to the Game Server
#------------------------------------------------------------------------------

extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
#var ip = "73.67.218.85"
var port = 1909

func _ready():
	pass
	#ConnectToServer()
	
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	print("Succesfully connected")
	

#------------------------------------------------------------------------------
# GameServer Interface Functions
#------------------------------------------------------------------------------
func FetchSkillDamage(skill_name, requester):
	rpc_id(1, "FetchSkillDamage", skill_name, requester)
	
remote func ReturnSkillDamage(s_damage, requester):
	instance_from_id(requester).SetDamage(s_damage)


#------------------------------------------------------------------------------
# Stats: Name, Score.
#------------------------------------------------------------------------------
func FetchPlayerStats(player_name, requester):
	rpc_id(1, "FetchPlayerStats", player_name, requester)

remote func ReturnPlayerStats(gs_player_stats, requester):
	print("Clicker score: " + str(gs_player_stats.ClickerScore))
	get_node("/root/GameClient/MainUI/PlayerStats").LoadPlayerStats(gs_player_stats)
