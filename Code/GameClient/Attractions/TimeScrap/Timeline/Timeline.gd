extends Tabs
class_name Timeline

const EVENT_PS: PackedScene = preload("res://Attractions/Timelines/TimelineEvent/TimelineEvent.tscn")

onready var EVENTS_CONTAINER := $VBoxContainer/ScrollContainer/EventsContainer
onready var TITLE_UI := $VBoxContainer/Title
onready var DESCRIPTION_UI := $VBoxContainer/Description

var title: String
var description: String
var events_data
var events: Array

func Init(timeline_data: Dictionary):
	name = timeline_data.title
	title = timeline_data.title
	description = timeline_data.description
	events_data = timeline_data.events
	return self

func _ready():
	UpdateUI()

func UpdateUI():
	TITLE_UI.text = title
	DESCRIPTION_UI.text = description
	#ClearEvents()
	#LoadEvents()

func ClearEvents():
	for node in EVENTS_CONTAINER.get_children():
		node.queue_free()


#-------------------
func NewEvent(title: String, description: String, begin_time: Dictionary, end_time: Dictionary, begin_accuracy: Dictionary, end_accuracy: Dictionary, color: Color):
	var event = EVENT_PS.instance()
	event.title = title
	event.description = description
	event.begin_time = begin_time
	event.end_time = end_time
	event.begin_accuracy = begin_accuracy
	event.end_accuracy = end_accuracy
	event.color = color
	EVENTS_CONTAINER.add_child(event, true) # Keep name.


func SaveEvents():
	var data = {"timeline_title": "Ottoman Empire",
				"timeline_description": "The borders of civilization moving.",
				"events":
				[
					{"title": "Found what I'm looking for.",
					"description": "Boopoopedoop.",
					"begin_time": {"day":13, "dst":false, "hour":7, "minute":29, "month":12, "second":33, "weekday":1, "year":2021},
					"end_time": {"day":13, "dst":false, "hour":7, "minute":29, "month":12, "second":33, "weekday":0, "year":2022}},
					{"title": "Found what I'm looking for.",
					"description": "Boopoopedoop.",
					"begin_time": {"day":13, "dst":false, "hour":7, "minute":29, "month":12, "second":33, "weekday":1, "year":2021},
					"end_time": {"day":13, "dst":false, "hour":7, "minute":29, "month":12, "second":33, "weekday":0, "year":2022}}
				]}

	Tools.WriteJSON("res://Data/my_timeline.json", data)

