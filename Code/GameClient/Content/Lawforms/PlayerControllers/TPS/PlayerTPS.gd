extends KinematicBody

onready var PIVOT := $CameraPivot

export var MouseSenesitivity = 0.01
export var speed: float = 30 # m/s.
var direction: Vector3 # 0.0 - 1.0
var velocity: Vector3
var gravity: Vector3
var jump_impulse: Vector3

# Happens one time.
func _ready():
	gravity = Vector3.DOWN * 9.8
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Happens every frame.
func _process(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction += -transform.basis.z
		print("Up")
		
	if Input.is_action_pressed("move_down"):
		direction += transform.basis.z
		print("Down")
		
	if Input.is_action_pressed("move_left"):
		direction += -transform.basis.x
		print("Left")
		
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		print("Right")
	
	if Input.is_action_just_pressed("jump"):
		gravity *= -1
		print("jump")
		
	direction = direction.rotated(Vector3.UP, PIVOT.rotation.y).normalized()
	velocity = speed * direction + gravity 
	move_and_slide(velocity, Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
		PIVOT.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
