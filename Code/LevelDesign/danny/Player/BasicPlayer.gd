extends KinematicBody


#Movement
export var speed: float = 10.0
export var jumpPower: float = 100.0
const GRAVITY: Vector3 = Vector3.DOWN * 6
var velocity: Vector3

#Nodes
onready var model = $Model
onready var cameraArm = $CameraArm


func _ready():
	pass


func _process(delta):
	var inputDir = Vector3.ZERO
	var zSpeed = velocity.y
	
	#Get input vector
	if Input.is_action_pressed("move_up"):
		inputDir += Vector3(0, 0, -1)
	if Input.is_action_pressed("move_down"):
		inputDir += Vector3(0, 0, 1)
	if Input.is_action_pressed("move_left"):
		inputDir += Vector3(-1, 0, 0)
	if Input.is_action_pressed("move_right"):
		inputDir += Vector3(1, 0, 0)
	
	#Rotate input vector in direction of camera
	inputDir = inputDir.rotated(Vector3.UP, cameraArm.rotation.y)
	
	#Check for jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		zSpeed = jumpPower
	
	#Turn player towards direction of movement
	if inputDir.length() > 0:
		model.look_at(to_global(inputDir), Vector3.UP)
	
	#Save move velocity vector
	velocity = inputDir.normalized() * speed + GRAVITY + Vector3.UP * zSpeed


func _physics_process(delta):
	#Move player
	velocity = move_and_slide(velocity, Vector3.UP)
	
	#Move camera
	cameraArm.translation = translation
