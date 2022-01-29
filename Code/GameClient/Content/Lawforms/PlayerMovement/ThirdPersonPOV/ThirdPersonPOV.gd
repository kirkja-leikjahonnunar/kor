extends KinematicBody

const ONE_G = 9.807 # m/s²
onready var PIVOT := $CameraPivot

export var MouseSenesitivity: float = 0.005
export var AccelerationRate: float = 0.666
export var BreakDecay: float = 0.95 # Damp? Dammping?
export var IsFlying: bool = true

var velocity: Vector3 # Current velocity vector.
var thrust: Vector3 # Thrust vector from the user's keyboard, mouse, or gamepad.
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
	thrust = Vector3.ZERO

	# TODO: Add gamepad support.
	if Input.is_action_pressed("move_forward"):
		thrust += -transform.basis.z * AccelerationRate
	if Input.is_action_pressed("move_back"):
		thrust += transform.basis.z * AccelerationRate
	if Input.is_action_pressed("move_left"):
		thrust += -transform.basis.x * AccelerationRate
	if Input.is_action_pressed("move_right"):
		thrust += transform.basis.x * AccelerationRate
	
	# Fly.	
	if Input.is_action_pressed("move_up"):
		thrust += -transform.basis.y * AccelerationRate
	if Input.is_action_pressed("move_down"):
		thrust += transform.basis.y * AccelerationRate
	
	if Input.is_action_pressed("jump"):
		pass
	if Input.is_action_pressed("break"):
		velocity *= BreakDecay
		
	# Orient the thrust around the player's y axis, so the [wsad] isn't orientent to true north.
	thrust = thrust.rotated(Vector3.UP, PIVOT.rotation.y).normalized()

	
#	if velocity.length() < 20:
	velocity += thrust
		
	move_and_slide(velocity, Vector3.UP) # Includes delta_time.

func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
		PIVOT.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
