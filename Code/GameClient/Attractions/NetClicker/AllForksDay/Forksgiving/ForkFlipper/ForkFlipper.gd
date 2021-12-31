#==============================================================================
# The Player class for this mini-game.
#==============================================================================

extends NetPlayer
class_name ForkFlipper

onready var CLICKS_LABEL = $CardBG/VBoxContainer/ClicksLabel
onready var NICKNAME_LABEL = $CardBG/VBoxContainer/NicknameLabel

#func _ready():
#	GameServer.NC_RequestUpdate()

func _process(delta_time):
	if Input.is_action_just_pressed("Click"):
		print("Click")

func _on_Button_pressed():
	#GameServer.NC_UpdatePlayerClicks(my_db_id)
	pass
	
func _on_Timer_timeout():
	#GameServer.NC_RequestUpdate()
	pass


#func Update(data: Dictionary):
#
#	my_id = data["ID"]
#	my_name = data["Name"]
#	my_clicks = data["Clicks"]
#	my_color = Color.darkgoldenrod
#
#	# Control params.
#	name = my_name
#	size_flags_horizontal = SIZE_EXPAND_FILL
#	size_flags_vertical = SIZE_EXPAND_FILL
#
#	# Update the UI.
#	NICKNAME_LABEL.set_text(my_name)
##	COLOR.color = my_color
#	CLICKS_LABEL.text = str(my_clicks)
