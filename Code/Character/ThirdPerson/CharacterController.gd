#
# Mixed third and first person character controller.
#

extends CharacterBody3D


@export var SPEED := 5.0
@export var SPRINT_SPEED := 10.0
@export var ROTATION_SPEED := .03
@export var JUMP_VELOCITY := 8.5

@export var allow_fp : bool = true # allow First Person mode
@export var min_camera_distance := 0.5  # below this, switch to 1st person
@export var max_camera_distance := 5.0  # below this, switch to 1st person
@export var zoom_amount := .2 #amound to zoom each wheel click

@export var mouse_sensitivity := .02
@export var invert_y := false
@export var invert_x := true
@export var allow_mouse_toggle := true


class CameraSettings: # TODO: develop this to be easier to load/save configs
	var fov := 75.0
	var head_height := 1.5
	var cam_h_offset := .25
	var cam_back_offset := .25
	var cam_top_offset := 0.0
	var camera_mode = CameraMode.Third
	var allow_first_person := true
	var min_pitch := -PI/2
	var max_pitch := PI/2
	var min_dist := .2 # beneath this transfers to 1st person
	var max_dist := 10


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# to help smooth out the player movement:
var target_velocity := Vector3()
var velocity_damp := .1

@onready var camera_rig    = $CameraRig
@onready var camera_target = $CameraRig/Target
@onready var camera_pitch  = $CameraRig/Target/SpringArm3D
@onready var camera_boom   = $CameraRig/Target/SpringArm3D
@onready var player_model  = $PlayerMesh
var camera_gamma := 0.0  # applied to camera_pitch node, rotation around player x axis
var min_camera_pitch := -PI/2
var max_camera_pitch := PI/2
var cam_h_shift := 0.0   # shift left or right off the player
var cam_v_shift := 0.0   # shift front or back
var cam_vv_shift := 0.0  # shift vertically to avoid head
var cam_v_offset := 0.0  # distance from player base to optimal camera height

enum CameraHover { Left, Right, Over } # How to center player in 3rd person view
var camera_hover := CameraHover.Over

enum CameraMode { Default, First, Third, VR } # TODO: VR!
#@export_enum(CameraMode) var camera_mode : int = CameraMode.Third <- how to export named enum??
var camera_mode = CameraMode.Default

@onready var spawn_position := position

##--------------------------- Run Loop Functions -----------------------------

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if camera_mode == CameraMode.First: SetFirstPerson()
	else: SetThirdPerson()
	cam_v_shift = abs($Proxy_Back.position.z)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("char_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# rotate player
	var rotate_amount = 1.0 if Input.is_action_pressed("char_rotate_right") else 0.0 \
						- 1.0 if Input.is_action_pressed("char_rotate_left") else 0.0
	if abs(rotate_amount) > 1e-5: camera_rig.rotate(Vector3(0,-1,0), delta * 60 * ROTATION_SPEED * rotate_amount)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = -Input.get_vector("char_strafe_left", "char_strafe_right", "char_forward", "char_backward")
	var player_dir = camera_rig.transform.basis * Vector3(input_dir.x, 0, input_dir.y) # now in Player space
	#print (player_dir)
	var direction = (transform.basis * player_dir).normalized() # now in world space
	
	var speed = SPRINT_SPEED if Input.is_action_pressed("char_sprint") else SPEED
	SetCharTilt(player_dir * speed / SPEED)
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else: # damp toward 0
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	#print ("velocity: ", velocity)
	var dpos = position
	move_and_slide()
	dpos -= position # this is world coordinates change in position


func _process(_delta):
	pass

func _input(event):
	# turn off mouse if you click
	if event is InputEventMouseButton:
		SetMouseVisible(false)
	
	# pan camera with mouse
	elif event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			HandleCameraMove(-event.relative.x * mouse_sensitivity,
							event.relative.y * mouse_sensitivity)

func _unhandled_input(_event):
	# toggle mouse on/off
	if allow_mouse_toggle && Input.is_action_just_pressed("char_toggle_mouse"):
		SetMouseVisible(Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	
	# camera zoom in and out
	if Input.is_action_just_pressed("char_zoom_in"):    HandleZoom(-zoom_amount)
	elif Input.is_action_just_pressed("char_zoom_out"): HandleZoom(zoom_amount)
	
	# change if camera hovers off to left, right, or center of player
	if camera_mode == CameraMode.Third && Input.is_action_just_pressed("char_camera_hover"):
		HandleHoverToggle()


##--------------------------- Handler Functions -----------------------------

var target_rotation := 0.0
var target_tilt := 0.0
var tilt_damp := .2
var rotation_damp := .3

# Assuming direction is in player space, make player mesh point z in that direction, and also lean in that direction
func SetCharTilt(direction: Vector3):
	if direction.length() != 0: 
		var amount = sqrt(direction.x*direction.x + direction.z*direction.z)
		target_rotation = -atan2(-direction.x, direction.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, target_rotation, rotation_damp)
		#print ("angle: ", atan2(-direction.x, direction.z))
		target_tilt = amount * .1 #* sign(direction.y)
		player_model.rotation.x = lerp_angle(player_model.rotation.x, target_tilt, tilt_damp)
		#print ("tilt: ", rad2deg(amount * tilt_damp))
	else:
		player_model.rotation.x = lerp_angle(player_model.rotation.x, 0, tilt_damp)


func HandleCameraMove(x,y):
	if invert_x: x = -x
	if invert_y: y = -y
	#camera_rig.rotation.y += x
	camera_rig.rotate(Vector3(0,1,0), x)
	camera_gamma = clamp(camera_gamma + y, min_camera_pitch, max_camera_pitch)
	SetCameraHoverTarget()


func SetMouseVisible(yes: bool):
	if yes:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func HandleZoom(amount):
	if amount < 0:
		print("zoom in")
		if camera_boom.spring_length + amount < min_camera_distance:
			SetFirstPerson()
		else:
			camera_boom.spring_length = clamp(camera_boom.spring_length+amount,
											min_camera_distance, max_camera_distance)
	elif amount > 0:
		print("zoom out")
		if camera_mode == CameraMode.First:
			SetThirdPerson()
		else:
			camera_boom.spring_length = clamp(camera_boom.spring_length+amount,
											min_camera_distance, max_camera_distance)


func HandleHoverToggle():
	match camera_hover:
		CameraHover.Left:  camera_hover = CameraHover.Right
		CameraHover.Right: camera_hover = CameraHover.Over
		CameraHover.Over:  camera_hover = CameraHover.Left
	SetHoverVars()
	SetCameraHoverTarget()


func SetHoverVars():
	if camera_mode == CameraMode.First:
		cam_v_offset = $Proxy_FPS.position.y 
		cam_v_shift  = 0
		cam_vv_shift = 0
		
	elif camera_mode == CameraMode.Third:
		match camera_hover:
			CameraHover.Right:
				cam_h_shift = $Proxy_Right.position.x
				cam_v_offset = $Proxy_Right.position.y
			CameraHover.Over:
				cam_h_shift = 0
				cam_v_offset = $Proxy_FPS.position.y
			CameraHover.Left:
				cam_h_shift = $Proxy_Left.position.x
				cam_v_offset = $Proxy_Left.position.y
		cam_v_shift = abs($Proxy_Back.position.z)


# Set the camera_target position to point to the proper target. 
# Note camera_gamma, and cam_* need to be set beforehand.
func SetCameraHoverTarget():
	camera_pitch.rotation.x = camera_gamma
	var cosg = cos(camera_gamma) # note: will be 0..1..0
	var sing = sin(camera_gamma) # note: will be -1..0..1
	
	#print ("hoff: ", cam_h_shift, ", voff: ", cam_v_offset, ", v: ", cam_v_shift, ", vv: ", cam_vv_shift, " target.pos: ", camera_target.global_transform.origin)
	#print ("cam_v_shift: ", cam_v_shift)
	camera_target.position = Vector3(cam_h_shift * cosg,
								cam_v_offset + cam_vv_shift * cosg,
								-cam_v_shift * sing)


# Turn on the 3rd person player mesh, and move camera to minimum distance if necessary.
func SetThirdPerson():
	#if camera_mode == CameraMode.Third: return
	print ("Set 3rd person")
	camera_mode = CameraMode.Third
	if camera_boom.spring_length < min_camera_distance: 
		camera_boom.spring_length = min_camera_distance
	#cam_v_offset = $Proxy_Over.position.y
	#cam_v_shift  = $Proxy_FPS.position.y
	#cam_vv_shift = $Proxy_Over.position.y - cam_v_shift # gets added to cam_v_offset
	SetHoverVars()
	SetCameraHoverTarget()
	$PlayerMesh.visible = true


# Turn off the player mesh, and move camera to Proxy_FPS position.
#TODO: replace other player meshes with first person hands
func SetFirstPerson():
	if !allow_fp: return
	print ("Set 1st person")
	#if camera_mode == CameraMode.First: return
	camera_mode = CameraMode.First
	camera_target.position = $Proxy_FPS.position
	camera_boom.spring_length  = 0
	cam_v_offset = camera_target.position.y 
	cam_v_shift  = 0
	cam_vv_shift = 0
	$PlayerMesh.visible = false


func Use1(node):
	print("Use1: ", node.name)

func Use2(node):
	print("Use2: ", node.name)


