extends KinematicBody
class_name Voidling

# Signals.
signal attacked(damage)
const DAMAGE: int = 25
func attack(damage: int = DAMAGE) -> void:
	emit_signal("attacked", damage)

# Hook up the constant resources.
const BEACON_PS: PackedScene = preload("res://Actors/Beacon/Beacon.tscn")

onready var FLOORCAST: RayCast = $FloorCast
onready var APPARITION: Area = $Apparition
onready var LASERCAST: RayCast = $Apparition/LaserCast

enum TravelMode { GLIDE, WALK }

# Properties.
export var MouseSenesitivity: float = 0.01
export var JoypadLookSpeed: float = 5.0
export var PrimaryColor: Color = Color.purple
export var SecondaryColor: Color = Color.chartreuse
export var EmissionColor: Color = Color.black
export var thrust_power: float = 0.3 # m/s
export var max_speed: float = 1.0   # m/s not m/s tho :(
export var min_speed: float = 0.01   # m/s
export var break_power: float = 0.95 # Good enough friction.

# Motion.
export var travel_mode = TravelMode.GLIDE

var velocity: Vector3 = Vector3.ZERO
var gravity_multiplier: float = 0.5

var jump_impulse: float = 50.0
var is_jumping: bool = false



# Init() variables.
var my_main: Node
var my_planet: Planet
var my_pronouns: String = "all / any"
#var gravity_point: Vector3 = Vector3.ZERO


#------------------------------------------------------------------------------
# Initialize()
#------------------------------------------------------------------------------
func Init(main: Node, planet: Planet, pronouns: String) -> Voidling:
	my_main = main
	my_pronouns = pronouns
	my_main.Hey("Hey Main thank's for spawning me.\nYours truley,\n- %s" % [self.pronouns])
	
	var material: Material = $Apparition/MeshInstance.get_surface_material(0)
	material.set_shader_param("Color", PrimaryColor)
	material.set_shader_param("Emission", EmissionColor)
	
	$Apparition/Column.process_material.set_color(SecondaryColor)
	$Apparition/CentralLight.set_color(SecondaryColor)
	
	return self


#------------------------------------------------------------------------------
# Racast logic.
#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
# Process each frame in the main game loop.
# The time between the last frame and this one is stored in delta_time.
#------------------------------------------------------------------------------
func _process(delta_time: float) -> void:
	if travel_mode == TravelMode.GLIDE:
				
		var thrust_vector: Vector3 = Vector3.ZERO # Set to zero every time through.
		
		# The keyboard bit.
		if Input.is_action_pressed("move_forward"):
			thrust_vector -= Vector3(sin(APPARITION.rotation.y), 0, cos(APPARITION.rotation.y))
		if Input.is_action_pressed("move_back"):
			thrust_vector += Vector3(sin(APPARITION.rotation.y), 0, cos(APPARITION.rotation.y))
		if Input.is_action_pressed("move_left"):
			thrust_vector -= APPARITION.transform.basis.x
		if Input.is_action_pressed("move_right"):
			thrust_vector += APPARITION.transform.basis.x
		
		
		
		
#		if Input.is_action_just_pressed("jump"):
#			thrust_vector += -gravity_vector * jump_impulse
#			print("Jump")

		if Input.is_action_just_released("jump"):
			print("Unjump")
					
		# Playing around.
		var distance_to_planet: float = my_planet.translation.distance_to(self.translation)
		print(distance_to_planet)
		
		#gravity_vector.distance_to(gravity_point)
		#gravity_vector.direction_to(gravity_point)
		#gravity_vector.reflect(Vector3.UP)
		#thrust_vector += gravity_vector * (distance_to_planet * gravity_multiplier)
		

		if Input.is_action_pressed("move_up"):
			thrust_vector -= Vector3.UP
		if Input.is_action_pressed("move_down"):
			thrust_vector -= Vector3.DOWN

		# The gamepad bit.
		APPARITION.rotate_y(-(Input.get_action_strength("look_right") - Input.get_action_strength("look_left")) * JoypadLookSpeed * delta_time) # Yaw.
		APPARITION.rotate_object_local(Vector3.RIGHT, -(Input.get_action_strength("look_down") - Input.get_action_strength("look_up")) * JoypadLookSpeed * delta_time) # Pitch.

		# Any thrusting going on?
		if thrust_vector != Vector3.ZERO:
			velocity += thrust_vector * thrust_power * delta_time
			
			
			
		# Brakes for all.
		if Input.is_action_pressed("appy_breaks"):
			velocity *= break_power
			
			
		# Drop Beacon.
		if Input.is_action_just_pressed("drop_beacon") and FLOORCAST.is_colliding():
			var collision_point: Vector3 = FLOORCAST.get_collision_point()
			
			var beacon: Beacon = BEACON_PS.instance().Init(PrimaryColor, SecondaryColor)
			#beacon.Initialize(PrimaryColor, SecondaryColor)
			beacon.translation = collision_point
			self.main.VOID.add_child(beacon)
			print("Beacon dropped.")

	translate(velocity) #velocity = move_and_slide(velocity)
	Raycast()


#------------------------------------------------------------------------------
# Input.
#------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if travel_mode == TravelMode.GLIDE:
		
		# The mouse bit.
		if event is InputEventMouseMotion:
			if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or \
			Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or \
			Input.is_action_pressed("enable_steering"):
				self.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
				APPARITION.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
			else:
				APPARITION.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
				APPARITION.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
				
			
	




	
	

#export var reset_to_zero: bool = false setget reset_zero
#func reset_zero(newVar):	
#	if Engine.editor_hint:
#		if newVar:
#			print("On")
#			reset_to_zero = true
#		else:
#			print("Off")
#			reset_to_zero = false

