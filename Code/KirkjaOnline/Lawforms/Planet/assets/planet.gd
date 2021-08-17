extends Spatial
class_name Planet

# Nodes.
onready var ATMO: StaticBody = $Atmo
onready var ATMO_MESH: MeshInstance = $Atmo/AtmoMesh

onready var GROUND: StaticBody = $Ground
onready var GROUND_MESH: MeshInstance = $Ground/GroundMesh

# Properties.
export var atmo_radius: float = 2
export var atmo_color: Color = Color.white

export var ground_radius: float = 3
export var ground_color: Color = Color.blue

#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready() -> void:
	ATMO.scale_object_local(Vector3.ONE) #(atmo_radius, atmo_radius, atmo_radius))
	GROUND.scale_object_local(Vector3.ONE)
	ATMO_MESH.get_surface_material(0).set_shader_param("FresnelColor", atmo_color)
	GROUND_MESH.get_surface_material(0).set_shader_param("FresnelColor", ground_color)
