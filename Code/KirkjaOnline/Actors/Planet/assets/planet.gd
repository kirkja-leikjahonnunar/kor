#tool
extends Spatial
class_name Planet

export var Primary: Color = Color.white
export var Secondary: Color = Color.blue

func _ready():
	$Area/GroundMesh.get_surface_material(0).set_shader_param("FresnelColor", Primary)
	$Area/AtmoMesh.get_surface_material(0).set_shader_param("FresnelColor", Secondary)
