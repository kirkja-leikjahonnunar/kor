extends Node

const TIMELINE_PS: PackedScene = preload("res://Attractions/TimeScrap/Timeline/Timeline.tscn")
const EVENT_PS: PackedScene = preload("res://Attractions/TimeScrap/TimelineEvent/TimelineEvent.tscn")
onready var TIMELINE_TABS := $UI/TimelineTabs

var file_path: String = "res://Data/my_timeline.json"
var timelines_data: Dictionary
var timelines: Array

func _ready():
	LoadTimelines(file_path)

func LoadTimelines(path: String):
	timelines_data = Tools.ReadJSON(path)

	# Inctance Loop.
	for timeline_data in timelines_data.timelines:
		var timeline = TIMELINE_PS.instance().Init(timeline_data)
		for event_data in timeline_data.events:
			var event = EVENT_PS.instance().Init(event_data)
			timeline.events.append(event)

		timelines.append(timeline)

	# Add Children.
	for timeline in timelines:
		TIMELINE_TABS.add_child(timeline, true)
		for event in timeline.events:
			timeline.EVENTS_CONTAINER.add_child(event)


func _on_Save_pressed():
	Tools.WriteJSON("res://Data/my_timeline.json", timelines_data)

func _on_Load_pressed():
	LoadTimelines(file_path)

func _on_Clear_pressed():
	pass # Replace with function body.

