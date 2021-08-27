tool
extends Spatial
class_name Planet

# Nodes.
onready var ATMO: Area = $Atmo
onready var ATMO_MESH: MeshInstance = $Atmo/AtmoMesh
onready var GROUND: StaticBody = $Ground
onready var GROUND_MESH: MeshInstance = $Ground/GroundMesh

# Properties.
export var mass: float = 0.1
export var atmo_radius: float = 4.0 setget set_atmo_radius
export var atmo_color: Color = Color.blue setget set_atmo_color
export var ground_radius: float = 2.0 setget set_ground_radius
export var ground_color: Color = Color.white setget set_ground_color

func set_atmo_radius(value):
	atmo_radius = value
	$Atmo.scale = Vector3(atmo_radius, atmo_radius, atmo_radius)
	
func set_atmo_color(value):
	atmo_color = value
	$Atmo/AtmoMesh.get_surface_material(0).set_shader_param("FresnelColor", atmo_color)
	
func set_ground_radius(value):
	ground_radius = value
	$Ground.scale = Vector3(ground_radius, ground_radius, ground_radius)
	
func set_ground_color(value):
	ground_color = value
	$Ground/GroundMesh.get_surface_material(0).set_shader_param("FresnelColor", ground_color)
	

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready() -> void:
	ATMO.scale = Vector3(atmo_radius, atmo_radius, atmo_radius)
