extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

onready var player_verification_process = $PlayerVerification


func _ready():
	StartServer()
	
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	
func _Peer_Connected(player_id):
	print("User: " + str(player_id) + " Connected")
	player_verification_process.Start(player_id)
	
	
func _Peer_Disconnected(player_id):
	print("User: " + str(player_id) + " Disconnected")


remote func FetchSkillDamage(skill_name, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var damage = ServerData.skill_data[skill_name].Damage
	rpc_id(player_id, "ReturnSkillDamage", damage, requester)
	print("Sending player damage: " + str(damage) + " to player")
	

remote func FetchPlayerStats(player_name: String, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var player_stats = ServerData.stats_data[player_name]
	rpc_id(player_id, "ReturnPlayerStats", player_stats, requester)
	print("Sending player score: " + str(player_stats["ClickerScore"]))

#remote func FetchPlayerStats():
#	var player_id = get_tree().get_rpc_sender_id()
#	var player_stats = get_node(str(player_id)).player_stats
#	rpc_id(player_id, "ReturnPlayerStats", player_stats)
#	print("Sending player score: " + str(player_stats["ClickerScore"]))
	
	
#
#remote func UpdatePlayerScore(requester):
#	var player_id = get_tree().get_rpc_sender_id()
#	# TODO: Watch player container again.
#
