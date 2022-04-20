extends Camera3D

@export var FollowProxy : NodePath
@onready var follow_proxy = get_node(FollowProxy)

@export var lerp_speed := 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	global_transform = global_transform.interpolate_with(follow_proxy.global_transform, lerp_speed*delta)

#func _process(delta):
#	global_transform = global_transform.interpolate_with(follow_proxy.global_transform, lerp_speed * Engine.get_physics_interpolation_fraction())
