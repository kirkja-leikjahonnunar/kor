extends KinematicBody

export var speed = 4 # m/s
var velocity: Vector3

func _ready():
	pass # Replace with function body.


func _process(_delta):

	velocity = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		velocity += Vector3.FORWARD
	if Input.is_action_pressed("back"):
		velocity += Vector3.BACK
	if Input.is_action_pressed("strafe_left"):
		velocity += Vector3.LEFT
	if Input.is_action_pressed("strafe_right"):
		velocity += Vector3.RIGHT
		
func _physics_process(_delta):
	move_and_slide(velocity * speed)

