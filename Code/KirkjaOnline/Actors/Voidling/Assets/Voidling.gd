tool
extends Spatial
class_name Voidling

# Tool vaiables. Public in editor.
export var PrimaryColor: Color = Color.purple
export var SecondaryColor: Color = Color.chartreuse
export var MouseSensitivityX: float = 0.01
export var MouseSensitivityY: float = 0.01
export var CameraLag: float = 0.0


# Class variables.
var main: Node = null
# TODO: Does this message apear anywhere like the todo list in VS?

# Initialize.
func Initialize(main: Node):
	self.main = main
	self.main.Hey()
	

####################
# Godot functions. #
####################

# Input.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		# Third person controls.
		if true: # camera_input_mode == CameraInputMode.THIRD_PERSON:			
			self.rotate_y(event.get_relative().x * -MouseSensitivityX) # Yaw.
			self.rotate_object_local(Vector3.RIGHT, event.get_relative().y * -MouseSensitivityY) # Pitch.


#export var reset_to_zero: bool = false setget reset_zero
#func reset_zero(newVar):	
#	if Engine.editor_hint:
#		if newVar:
#			print("On")
#			reset_to_zero = true
#		else:
#			print("Off")
#			reset_to_zero = false
