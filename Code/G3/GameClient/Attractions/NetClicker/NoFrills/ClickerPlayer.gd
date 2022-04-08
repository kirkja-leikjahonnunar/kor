extends Control
class_name ClickerPlayer

onready var CLICKS_LABEL = $CardBG/VBoxContainer/ClicksLabel
onready var NICKNAME_LABEL = $CardBG/VBoxContainer/NicknameLabel

# Local variables.
var we_are_ready: bool = false

var my_id: int
var my_name: String
var my_clicks: int
var my_color: Color


func _ready():
	GameServer.NC_RequestUpdate()

func Init(data: Dictionary):
	
	# Class variables.
	my_id = data["ID"]
	my_name = data["Name"]
	my_clicks = data["Clicks"]
	my_color = Color.darkgoldenrod
	
	# Control params.
	name = my_name
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL


func Update(data: Dictionary):
	
	my_id = data["ID"]
	my_name = data["Name"]
	my_clicks = data["Clicks"]
	my_color = Color.darkgoldenrod
	
	# Control params.
	name = my_name
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL
	
	# Update the UI.
	NICKNAME_LABEL.set_text(my_name)
#	COLOR.color = my_color
	CLICKS_LABEL.text = str(my_clicks)


func _on_Button_pressed():
	GameServer.NC_UpdatePlayerClicks(my_id)


func _on_Timer_timeout():
	GameServer.NC_RequestUpdate()
