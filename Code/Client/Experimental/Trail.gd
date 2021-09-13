extends Line2D

var target
var point
export var target_path: NodePath
export var trail_length = 10


func _ready() -> void:
	target = get_node(target_path)
	pass
	

func _process(_delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	point = target.global_position
	add_point(point)
	
	while get_point_count() > trail_length:
		remove_point(0)
	pass
