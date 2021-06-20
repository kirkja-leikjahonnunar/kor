tool
extends Spatial

export var reset_to_zero: bool = false setget reset_zero

export var primary_color = Color.purple
export var secondary_color = Color.chartreuse

func reset_zero(newVar):	
	if Engine.editor_hint:
		if newVar:
			print("On")
			reset_to_zero = true
		else:
			print("Off")
			reset_to_zero = false
			



func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta_time):
	#rotate(Vector3.UP, 180 * delta_time)
	pass


