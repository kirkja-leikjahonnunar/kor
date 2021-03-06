extends KinematicBody

const ONE_G = 9.807 # m/s².
const MY_G = 40

onready var PIVOT := $CameraPivot
onready var SPEED_UI := $UI/SpeedUI
onready var VELOCITY_UI := $UI/VelocityUI

export var MouseSenesitivity: float = 0.005 # TODO: Doc magic number.

# m/s.
export var IsGliding: bool = true # Use flying or sticky gravity. Magnetic stick?
export var MaxSpeed: float = 10.0
export var MinSpeed: float = 0.1
export var AccelerationRate: float = 0.666
export var BreakDecay: float = 0.95 # Damping.

var velocity: Vector3 # velocity =  vector.
var thrust: Vector3 # Thrust vector from the user's keyboard, mouse, or gamepad.
var gravity: Vector3 = Vector3.DOWN * ONE_G # Gravitational velocity vector can point toward other directions.

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	MovementLoop(delta)

	# TODO: Testing the movement.
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		

func MovementLoop(delta_time):
	# Calculate the thrust
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
	if Input.is_action_pressed("break"):
		velocity *= BreakDecay
	
	if IsGliding:
		if Input.is_action_pressed("move_up"):
			thrust += -transform.basis.y * AccelerationRate
		if Input.is_action_pressed("move_down"):
			thrust += transform.basis.y * AccelerationRate
	else:
		if Input.is_action_pressed("jump"):
			pass
			
		gravity *= delta_time #* gravity
		velocity += gravity
	
	# Orient the thrust around the player's y axis, so the [wsad] controls are relative to the viewport.
	thrust = thrust.rotated(Vector3.UP, PIVOT.rotation.y)#.normalized()

	# Add player input.
	velocity += thrust
	
	# Clamp the velocity's magnitude according to the speed properties.
	if velocity.length() < MinSpeed:
		velocity = Vector3.ZERO
	elif velocity.length() > MaxSpeed:
		velocity = velocity.normalized() * MaxSpeed
			
	move_and_slide(velocity, Vector3.UP) # Includes thrust delta_time.
	
	# UI.
	var speed = velocity.length()
	SPEED_UI.text = "Speed: %s" % speed
	VELOCITY_UI.text = "Velocity: %s" % velocity

func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
		PIVOT.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
