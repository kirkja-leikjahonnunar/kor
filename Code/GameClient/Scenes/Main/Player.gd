extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_state


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = 0 #ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	set_physics_process(false) #hack: something to do with main menu?


func _physics_process(delta):
	HandleMovement(delta)
	DefinePlayerState()


func DefinePlayerState():
	player_state = { "T": Time.get_ticks_msec(), "P": global_transform.origin }
	GameServer.SendPlayerState(player_state)


func HandleMovement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2(), SPEED)

	move_and_slide()


func _on_player_input_event(viewport, event, shape_idx):
	pass
	#if event is InputEventMouseButton:
	#	print ("Player input event")
