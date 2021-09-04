extends KinematicBody
class_name Voidling

# Signals.
signal attacked(damage)
const DAMAGE: int = 25
func attack(damage: int = DAMAGE) -> void:
	emit_signal("attacked", damage)

# Resources.
const BEACON_PS: PackedScene = preload("res://Lawforms/Beacon/Beacon.tscn")

# Nodes.
onready var FLOORCAST: RayCast = $FloorRay
onready var APPARITION: Area = $Apparition
onready var LASERCAST: RayCast = $Apparition/LaserRay

enum TravelMode { GLIDE, WALK }

# Properties.
export var MouseSenesitivity: float = 0.01
export var JoypadLookSpeed: float = 5.0
export var PrimaryColor: Color = Color.purple
export var SecondaryColor: Color = Color.chartreuse
export var EmissionColor: Color = Color.black

export var thrust_power: float = 0.3 # m/s
export var top_speed: float = 10.0   # m/s
export var stop_speed: float = 1.0   # m/s
export var break_power: float = 0.95 # Good enough friction.

# Body.
var my_main: Node
var my_planets: Array
var my_pronouns: String = "all / any"

# Motion.
export var travel_mode = TravelMode.GLIDE
var velocity: Vector3 = Vector3.ZERO

var can_jump: bool = false
var jump_impulse: float = 50.0


#------------------------------------------------------------------------------
# Initialize()
#------------------------------------------------------------------------------
func Init(main: Node, pronouns: String) -> Voidling:
	my_main = main
	my_pronouns = pronouns
	my_main.Hey("Hey Main thank's for spawning me.\nYours truley,\n- %s" % [self.my_pronouns])
	
	var material: Material = $Apparition/Pentagon.get_surface_material(0)
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
	$Apparition/Pentagon.rotate_y(13 * delta_time)
	if travel_mode == TravelMode.GLIDE:
		
		# Set to zero every time through.
		var thrust_vector: Vector3 = Vector3.ZERO
		var gravity_vector: Vector3 = Vector3.ZERO
		
		#------------------
		# The keyboard bit.
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
		
		velocity += thrust_vector * thrust_power
		
		# Check for max velocity and park_threshold
		if velocity.length() < stop_speed and thrust_vector == Vector3.ZERO:
			velocity = Vector3.ZERO
		elif velocity.length() > top_speed:
			velocity = velocity.normalized() * top_speed
			
		$VelocityRay.cast_to = velocity
		
		#-----------------------
		# Breaks / air friction.
		if Input.is_action_pressed("appy_breaks"):
			velocity *= break_power
			
		#-------------------------------------------
		# Calculate all the planets' gravity if any.
		for planet in my_planets:
			if planet is Planet: # Aparently an important check.
				gravity_vector += translation.direction_to(planet.translation) * planet.mass
				
		velocity += gravity_vector
		$FloorRay.cast_to = gravity_vector.normalized() * 2
			

		#---------------------------------
		# Jump if player is on the ground.
#		if Input.is_action_just_pressed("jump"):
#			thrust_vector += -gravity_vector * jump_impulse
#			print("Jump")

#		if Input.is_action_just_released("jump"):
#			print("Unjump")


		# The gamepad bit.
#		APPARITION.rotate_y(-(Input.get_action_strength("look_right") - Input.get_action_strength("look_left")) * JoypadLookSpeed * delta_time) # Yaw.
#		APPARITION.rotate_object_local(Vector3.RIGHT, -(Input.get_action_strength("look_down") - Input.get_action_strength("look_up")) * JoypadLookSpeed * delta_time) # Pitch.





		# Drop Beacon.
#		if Input.is_action_just_pressed("drop_beacon") and FLOORCAST.is_colliding():
#			var collision_point: Vector3 = FLOORCAST.get_collision_point()
#
#			var beacon: Beacon = BEACON_PS.instance().Init(PrimaryColor, SecondaryColor)
#			beacon.translation = collision_point
#			self.main.VOID.add_child(beacon)
#			print("Beacon dropped.")

		move_and_slide(velocity, Vector3.DOWN)
		#move_and_slide_with_snap(velocity, gravity_vector, Vector3.ZERO)

		Raycast()


#------------------------------------------------------------------------------
# Input.
#------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if travel_mode == TravelMode.GLIDE:
		
		# The mouse bit.
		if event is InputEventMouseMotion:
#			if Input.is_action_pressed("move_forward") \
#			or Input.is_action_pressed("move_back") \
#			or Input.is_action_pressed("move_left") \
#			or Input.is_action_pressed("move_right") \
			if Input.is_action_pressed("enable_steering"):
				self.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
				APPARITION.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
			else:
				APPARITION.rotate_y(event.get_relative().x * -MouseSenesitivity) # Yaw.
				APPARITION.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSenesitivity) # Pitch.
			

func _on_Apparition_area_entered(area):
	my_planets.append(area.get_owner())
	for planet in my_planets:
		print(planet.name)


func _on_Apparition_area_exited(area):
	my_planets.remove(my_planets.find(area.get_parent()))
	print("Pheew.")
