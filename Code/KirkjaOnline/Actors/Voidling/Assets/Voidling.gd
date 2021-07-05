# tool
extends Spatial
class_name Voidling

enum TravelMode { PUCK, WALK, FLY }

# Properties.
export var PrimaryColor: Color = Color.purple
export var SecondaryColor: Color = Color.chartreuse
export var EmissionColor: Color = Color.black
export var MouseSensitivityX: float = 0.01
export var MouseSensitivityY: float = 0.01
export var CameraLag: float = 0.0

# Motion.
# export var movement_speed: float = 10.0
export var travel_mode = TravelMode.PUCK

onready var KB: KinematicBody = $KinematicBody

# Class member variables.
var main: Node = null
var pronouns: String = "all / any" # warning-ignore:shadowed_variable
var gravity_vector: Vector3 = Vector3.DOWN # warning-ignore:shadowed_variable


######################
# Voidling Functions #
######################

# TODO: Does this message apear anywhere like the todo list in VS?

# Initialize.
func Initialize(main: Node, pronouns: String):
	self.main = main
	self.pronouns = pronouns
	self.main.Hey("Hey Main thank's for spawning me.\nYours truley,\n- %s" % [self.pronouns])
	var material = $KinematicBody/MeshInstance.get_surface_material(0)
	material.set_shader_param("Color", PrimaryColor)
	material.set_shader_param("Emission", EmissionColor)
	$KinematicBody/Column.process_material.set_color(SecondaryColor)
	$CentralLight.set_color(SecondaryColor)
	
###################
# Godot Functions #
###################

export var velocity: Vector3 = Vector3.ZERO
export var thrust_power: float = 0.5 # m/s
export var max_speed: float = 100.0  # m/s
export var break_power: float = 0.95

#----------
# Update().
#----------
func _process(delta_time: float) -> void:
	
	var thrust_direction: Vector3 = Vector3.ZERO
	
	# Air puck mode: world coords.
	if travel_mode == TravelMode.PUCK:
		if Input.is_action_pressed("move_forward"):
			thrust_direction += get_global_transform().basis.z
		if Input.is_action_pressed("move_back"):
			thrust_direction -= get_global_transform().basis.z
		if Input.is_action_pressed("move_left"):
			thrust_direction -= get_global_transform().basis.x
		if Input.is_action_pressed("move_right"):
			thrust_direction += get_global_transform().basis.x
	
	else:
		# Both WALK and FLY: local coords.	
		if Input.is_action_pressed("move_forward"):
			thrust_direction += Vector3.FORWARD	# Local coords.
		if Input.is_action_pressed("move_back"):
			thrust_direction += Vector3.BACK
		if Input.is_action_pressed("move_left"):
			thrust_direction += Vector3.LEFT
		if Input.is_action_pressed("move_right"):
			thrust_direction += Vector3.RIGHT

	# Brakes for everyone.
	if Input.is_action_pressed("breaks"):
		velocity *= break_power
		
	# Walking.
	if travel_mode == TravelMode.WALK:
		if Input.is_action_just_pressed("jump"):
			print("Jump start")
		if Input.is_action_just_released("jump"):
			print("Jump end")
		
	# Flying.
	elif travel_mode == TravelMode.FLY:
		if Input.is_action_pressed("move_up"):
			thrust_direction -= Vector3.UP
		if Input.is_action_pressed("move_down"):
			thrust_direction -= Vector3.DOWN


		
		
	# Update and use velocity.
	velocity += thrust_direction * thrust_power * delta_time
	translate(velocity)
	

# Input.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		
		if travel_mode == TravelMode.PUCK:
			self.rotate_y(event.get_relative().x * -MouseSensitivityX) # Yaw.
			self.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSensitivityY) # Pitch.
			
		if travel_mode == TravelMode.WALK:
			self.rotate_y(event.get_relative().x * -MouseSensitivityX) # Yaw.			
			KB.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSensitivityY) # Pitch.
			
		if travel_mode == TravelMode.FLY:
			self.rotate_y(event.get_relative().x * -MouseSensitivityX) # Yaw.
			self.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSensitivityY) # Pitch.
	
	
	
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
