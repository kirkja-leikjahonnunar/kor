#==============================================================================
# FORKSGIVING GDD
#
# A mini-game for NetClicker, in which:
#
# AI
# - There are 2 conveyerbelt-like spawning points.
# - <---* Forks spawn from the right, then travel to the left.
# - *---> Drawers spawn from the left, then move right.
# - When either are spawned, they randomly flip aroud their vertical axis.
#
# UX / Player Goal
# - The player clicks individual forks to flip them upside down or rightsideup based on the Drawers orientation.
# - The Player must match the Drawer and Fork orientation when they meet in the middle.
# - The player recieves a point for every successful match.
# - Every five successful matches the Drawers slow down for 5 seconds.
# - If it's not a sussessful match, the Fork drops and the Drawer continues moving on to the right.
#
# END GAME
# - If the Drawers reach the right hand side of the screen the game ends,
#   and the ScoreResults UI is displayed.
# - There are 2 buttons on the ScoreResults page: [Continue] [Quit].
#==============================================================================
extends Node
class_name Forksgiving

# Invitation.
onready var DRAWERS_FIELD := $DrawersField
onready var FORKS_FIELD := $ForksField
onready var INVITATION := $Invitation


# Game.
const DRAWER_PS: PackedScene = preload("res://Attractions/NetClicker/AllForksDay/Forksgiving/Drawer/Drawer.tscn")
const FORK_PS: PackedScene = preload("res://Attractions/NetClicker/AllForksDay/Forksgiving/Fork/Fork.tscn")

onready var UI := $UI
onready var FLIPPER := $ForkFlipper

var is_running: bool = false
var spawn_offset: float = 204 # 1024 / 5, and truncated.
var fork_speed_multiplier: float = 1.0
var drawer_speed_multiplier: float = 1.0


# Spawn another Drawer.
func _on_DrawerTimer_timeout():
	if is_running:
		var drawer: Drawer =  DRAWER_PS.instance()
		drawer.connect("landed", self, "SuccessfulLanding")
		drawer.position = Vector2(-spawn_offset, 0)
		drawer.speed *= drawer_speed_multiplier
		DRAWERS_FIELD.add_child(drawer)


# Spawn another Fork.
func _on_ForkTimer_timeout():
	if is_running:
		var fork: Fork = FORK_PS.instance()
		fork.position = Vector2(get_viewport().size.x, 0)
		fork.speed *= fork_speed_multiplier
		FORKS_FIELD.add_child(fork)


func SuccessfulLanding():
	print("Successful Landing.")
	UI.UpdateForksGiven(1)
	#GameServer.NC_UpdateForksGiven(UI.player_db_id, ) # HACK: Untested.
	
	
func UpdatePlayground(players_data_table: Array):
	for i in players_data_table.size():
		var player_name: String = players_data_table[i]["Name"]
		get_node("BG/Playground/" + player_name).Update(players_data_table[i])
	print("Update.")
