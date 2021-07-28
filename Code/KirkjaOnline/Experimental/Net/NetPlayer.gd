extends KinematicBody
class_name NetPlayer

var my_id: int = -1
var speed: float = 5.0
var direction: Vector3 = Vector3.ZERO


func Init(id: int) -> NetPlayer:
	my_id = id
	return self


func _physics_process(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	if is_network_master():
		move_and_slide(direction * speed, Vector3.UP)
