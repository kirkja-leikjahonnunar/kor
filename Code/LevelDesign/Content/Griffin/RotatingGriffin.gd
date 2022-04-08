tool
extends "res://Content/Griffin/Griffin.gd"

export var speed := .01


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	rotate(Vector3(1, 0, 0), delta * speed)


func _physics_process(delta):
	pass


