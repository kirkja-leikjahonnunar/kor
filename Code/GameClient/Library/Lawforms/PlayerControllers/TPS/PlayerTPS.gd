extends KinematicBody

export var speed: float = 10 # m/s.
var direction: Vector3 # 0.0 - 1.0
var velocity: Vector3
var gravity: Vector3
var jump_impulse: Vector3

# Happens one time.
func _ready():
	gravity = Vector3.DOWN * 9.8
	

# Happens every frame.
func _process(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction += Vector3(0, 0, -1)
		print("Up")
		
	if Input.is_action_pressed("move_down"):
		direction += Vector3(0, 0, 1)
		print("Down")
		
	if Input.is_action_pressed("move_left"):
		direction += Vector3(-1, 0, 0)
		print("Left")
		
	if Input.is_action_pressed("move_right"):
		direction += Vector3(1, 0, 0)
		print("Right")
	
	if Input.is_action_just_pressed("jump"):
		gravity *= -1
		print("jump")
		
	velocity = speed * direction + gravity 
	move_and_slide(velocity, Vector3.UP)
