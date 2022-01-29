extends KinematicBody

const ONE_G = 9.807 # m/s²
onready var PIVOT := $CameraPivot
export var MouseSenesitivity = 0.005

var direction: Vector3 # 0.0 - 1.0
var max_speed: float = 40.0
var speed: float = 0.0
var acceleration: float = 1 # meter / sec?

var gravity: Vector3 = Vector3.DOWN * ONE_G # Can point toward other directions.

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	MovementLoop(delta)

	# TODO: Testing the movement.
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	
func MovementLoop(delta_time):
	direction = Vector3.ZERO

	if Input.is_action_pressed("move_up"):
		direction += -transform.basis.z
	if Input.is_action_pressed("move_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction += -transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

#	if Input.is_action_just_pressed("jump"):
#		gravity *= -1
#		print("jump")

	if direction == Vector3.ZERO:
		speed = 0
	else:
		speed += acceleration * delta_time
		if speed > max_speed:
			speed = max_speed

	direction = direction.rotated(Vector3.UP, PIVOT.rotation.y).normalized()
	#print(direction)
	
	var velocity = speed * direction# + gravity 
	move_and_slide(velocity, Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
		PIVOT.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
