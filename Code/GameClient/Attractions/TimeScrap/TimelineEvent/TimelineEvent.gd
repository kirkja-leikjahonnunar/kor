extends PanelContainer
class_name TimelineEvent

onready var TITLE_UI: RichTextLabel = $Column/Title
onready var TITLE_EDIT_UI := $Column/Title/TitleEdit
onready var DESCRIPTION_UI := $Column/Description
onready var DESCRIPTION_EDIT_UI := $Column/Description/DescriptionEdit
#onready var COLOR_UI := $Panel/ColorPickerButton

var title: String
var description # bbcode compatable.
var begin_time: Dictionary
var end_time: Dictionary
var begin_accuracy: Dictionary
var end_accuracy: Dictionary
var color: Color

#------------------------------------------------------------------------------
# Using the '.instance().Init(data)' pattern.
# We can't set the UI elements yet.
# We don't have access to the nodes until '_ready()'.
#------------------------------------------------------------------------------
func Init(event_data):
	name = event_data.title
	title = event_data.title
	description = event_data.description
	begin_time = event_data.begin_time
	end_time = event_data.end_time
	begin_accuracy = event_data.begin_accuracy
	end_accuracy = event_data.end_accuracy
	color = Color(event_data.color.r, event_data.color.g, event_data.color.b, event_data.color.a)
	return self

func _ready():
	UpdateUI()
	if DESCRIPTION_UI.visible:
		ToggleDescriptionUI()

func UpdateUI():
	TITLE_UI.bbcode_text = title
	TITLE_EDIT_UI.text = title
	DESCRIPTION_UI.bbcode_text = description
	DESCRIPTION_EDIT_UI.text = description
#	COLOR_UI.color = color

func ToggleDescriptionUI():
	if DESCRIPTION_UI.visible:
		DESCRIPTION_UI.hide()
#		TITLE_UI.corner_raduis_bottom_left = 13
#		TITLE_UI.corner_raduis_bottom_right = 13
	else:
		DESCRIPTION_UI.show()
#		TITLE_UI.corner_raduis_bottom_right = 0
#		TITLE_UI.corner_raduis_bottom_right = 0

func EditDescription():
	if DESCRIPTION_EDIT_UI.visible:
		DESCRIPTION_EDIT_UI.text = description
	else:
		description = DESCRIPTION_EDIT_UI.text


func _on_Title_gui_input(event):
	if Input.is_action_just_pressed("Click"):
		ToggleDescriptionUI()
		print("Now!")

func _on_Description_gui_input(event):
	if Input.is_action_just_pressed("Click"):
		#EditDescription()
		print(event)

