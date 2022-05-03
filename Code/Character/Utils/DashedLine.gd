@tool
#class_name DashedLine3D
extends MultiMeshInstance3D


@export var from_point := Vector3():
	set(value):
		from_point = value
		UpdateDash()
@export var to_point := Vector3(1,0,0):
	set(value):
		to_point = value
		UpdateDash()
@export var color := Color(1.0, 1.0, 1.0):
	set(value):
		color = value
		UpdateDash()
@export var dash_length := 0.1:
	set(value):
		dash_length = value
		UpdateDash()
@export var dash_width := 0.05:
	set(value):
		dash_width = value
		UpdateDash()


func UpdateDash():
	print ("Update dash from ", from_point, " to ", to_point)
	var v := to_point - from_point
	var vlen = v.length()
	var num_dashes = vlen / (dash_length*2)
	if num_dashes > multimesh.instance_count:
		multimesh.instance_count = num_dashes
	multimesh.visible_instance_count = num_dashes
	multimesh.mesh.size = Vector3(dash_length, dash_width, dash_width)
	v = v.normalized()
	var axis = v.cross(Vector3(1,0,0))
	var angle = asin(axis.length());
	var b = Basis().rotated(axis.normalized(), -angle)
	for i in range(num_dashes):
		multimesh.set_instance_transform(i, Transform3D(b, from_point + v*(i * 2*dash_length)))


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
