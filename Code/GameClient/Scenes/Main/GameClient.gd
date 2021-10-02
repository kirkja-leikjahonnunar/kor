extends Node

var damage
var stats
		
func SetDamage(gs_damage):
	damage = gs_damage
	print("Ice Spear: " + str(damage) + " damage.")

func SetPlayerStats(gs_player_stats):
	stats = gs_player_stats
	print("Player Score: " + str(stats["ClickerScore"]) + "!!!")

func _on_Button_pressed():
	print("Requesting server data.")
	GameServer.FetchSkillDamage("Ice Spear", get_instance_id())
	#GameServer.FetchPlayerStats("unblinky", get_instance_id())
	GameServer.FetchPlayerStats("unblinky", get_instance_id())

