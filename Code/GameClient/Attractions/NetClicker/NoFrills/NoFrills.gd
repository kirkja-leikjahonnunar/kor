extends Node
class_name NoFrills

const PLAYER_PS: PackedScene = preload("res://Attractions/NetClicker/NoFrills/ClickerPlayer.tscn")
onready var PLAYGROUND = $BG/Playground
onready var BOOT_BUTTON = $BG/BootButton


#------------------------------------------------------------------------------
# Incoming 'data' = A db table of the current players and their current stats.
# data is an array of Dictionaries.
#------------------------------------------------------------------------------
func BootUpPlayground(nc_player_table_list: Array):
	# Loop through each player in the table.
	for i in nc_player_table_list.size():
		var player = PLAYER_PS.instance()
		player.Init(nc_player_table_list[i])
		PLAYGROUND.add_child(player)
		
		print("Instance added.")
#		print("Data: " + str(data[i])) # UpdateNetPlayer(data[i])


func UpdatePlayground(players_data_table: Array):
	for i in players_data_table.size():
		var player_name: String = players_data_table[i]["Name"]
		get_node("BG/Playground/" + player_name).Update(players_data_table[i])
	print("Update.")


# Boot Button
func _on_BootButton_pressed():
	BOOT_BUTTON.visible = false
	GameServer.NC_RequestBootUp(name) # HACK: Untested.
