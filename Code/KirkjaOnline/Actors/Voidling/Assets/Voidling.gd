extends KinematicBody
class_name Voidling

onready var signpost_ps: PackedScene = preload("res://Actors/Signpost/Signpost.tscn")

enum TravelMode { GLIDE, WALK }

# Properties.
export var MouseSensitivityX: float = 0.01
export var MouseSensitivityY: float = 0.01

export var PrimaryColor: Color = Color.purple
export var SecondaryColor: Color = Color.chartreuse
export var EmissionColor: Color = Color.black

# Motion.
export var travel_mode = TravelMode.GLIDE


# Class member variables.
var main: Node = null # warning-ignore:shadowed_variable
var pronouns: String = "all / any" # warning-ignore:shadowed_variable
var gravity_vector: Vector3 = Vector3.DOWN


onready var FLOORCAST: RayCast = $FloorCast
onready var APPARITION: Area = $Apparition
onready var LASERCAST: RayCast = $Apparition/LaserCast


var velocity: Vector3 = Vector3.ZERO
export var thrust_power: float = 0.3 # m/s
export var max_speed: float = 1.0   # m/s not m/s tho :(
export var min_speed: float = 0.01   # m/s
export var break_power: float = 0.95 # Good enough friction.

######################
# Voidling Functions #
######################

# TODO: Does this message apear anywhere like the todo list in VS?

# Initialize.
func Initialize(main: Node, pronouns: String):
	self.main = main
	self.pronouns = pronouns
	#self.main.Hey("Hey Main thank's for spawning me.\nYours truley,\n- %s" % [self.pronouns])
	
	var material: Material = $Apparition/MeshInstance.get_surface_material(0)
	material.set_shader_param("Color", PrimaryColor)
	material.set_shader_param("Emission", EmissionColor)
	
	$Apparition/Column.process_material.set_color(SecondaryColor)
	$Apparition/CentralLight.set_color(SecondaryColor)
	
###################
# Godot Functions #
###################
	# Messin' with StackOverflow.
	
	#var forward: Vector3 = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#var left: Vector3 = Vector3(sin(rotation.y - PI / 2), 0, cos(rotation.y - PI / 2))
	
	
	#Vector3 forward = new Vector3(-(float)Math.Sin(Rotation.y), 0, -(float)Math.Cos(Rotation.y));
	#Vector3 left = new Vector3((float)Math.Sin(Rotation.y - Math.PI/2), 0, (float)Math.Cos(Rotation.y - Math.PI/2));



#----------
# Update().
#----------
func _process(delta_time: float) -> void:
	if travel_mode == TravelMode.GLIDE:
		
#		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#		input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

#		var input_vector: Vector3 = Vector3.ZERO
#		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#		input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
#		input_vector = input_vector.normalized()
				
		var thrust_vector: Vector3 = Vector3.ZERO
		
		if Input.is_action_pressed("move_forward"):
			thrust_vector -= Vector3(sin(APPARITION.rotation.y), 0, cos(APPARITION.rotation.y))
		if Input.is_action_pressed("move_back"):
			thrust_vector += Vector3(sin(APPARITION.rotation.y), 0, cos(APPARITION.rotation.y))
		if Input.is_action_pressed("move_left"):
			thrust_vector -= APPARITION.transform.basis.x
		if Input.is_action_pressed("move_right"):
			thrust_vector += APPARITION.transform.basis.x
			
		if Input.is_action_pressed("move_up"):
			thrust_vector -= Vector3.UP
		if Input.is_action_pressed("move_down"):
			thrust_vector -= Vector3.DOWN


		
		if thrust_vector != Vector3.ZERO:
			velocity += thrust_vector * thrust_power * delta_time
			#velocity = velocity
			#velocity = move_and_slide(velocity)
			

			
		# Brakes for all.
		if Input.is_action_pressed("appy_breaks"):
			velocity *= break_power
			
		# Walking.
		if travel_mode == TravelMode.WALK:
			if Input.is_action_just_pressed("jump"):
				print("Jump start")
			if Input.is_action_just_released("jump"):
				print("Jump end")


			

			
		translate(velocity)
		Raycast()

	

# Racast logic.
func Raycast() -> void:
	if Input.is_action_just_pressed("enable_laser"):
		LASERCAST.set_enabled(true)
		FLOORCAST.set_enabled(true)
	elif Input.is_action_just_released("enable_laser"):
		LASERCAST.set_enabled(false)
		FLOORCAST.set_enabled(false)
	
	if LASERCAST.is_enabled() and LASERCAST.is_colliding():
		var other_object: Object = LASERCAST.get_collider()
		if other_object.owner is Bubble:
			other_object.queue_free()

	if FLOORCAST.is_enabled() and FLOORCAST.is_colliding():		
		if Input.is_action_just_pressed("post_sign"):
			var collision_point: Vector3 = FLOORCAST.get_collision_point()
			
			var signpost: Signpost = signpost_ps.instance()
			signpost.Initialize(PrimaryColor, SecondaryColor)
			signpost.translation = collision_point
			self.main.VOID.add_child(signpost)
			print("Post sign.")

	
	

# Input.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		if travel_mode == TravelMode.GLIDE:
			if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or \
			Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or \
			Input.is_action_pressed("enable_steering"):
				self.rotate_y(event.get_relative().x * -MouseSensitivityX) # Yaw.
				APPARITION.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSensitivityY) # Pitch.				
			else:
				APPARITION.rotate_y(event.get_relative().x * -MouseSensitivityX) # Yaw for Voidling node.
				APPARITION.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSensitivityY) # Pitch.
			
	
	
	
	# If you want to type like a Keyboard.
	#if event is InputEventKey:
	#	if event.is_action_pressed("move_forward", true):
	#		print("move_forward")


#export var reset_to_zero: bool = false setget reset_zero
#func reset_zero(newVar):	
#	if Engine.editor_hint:
#		if newVar:
#			print("On")
#			reset_to_zero = true
#		else:
#			print("Off")
#			reset_to_zero = false

