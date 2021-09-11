tool
extends Spatial
class_name Signpost

export var width: float = 1.024 setget set_width
export var font_size: float = 3.3 setget set_font_size

func set_width(value):
	width = value
	
func set_font_size(value):
	font_size = value
	
#------------------------------------------------------------------------------
#func Initialize(primary: Color, secondary: Color) -> void:
#	var material: Material = $Post.get_surface_material(0)
#	material.set_shader_param("Color", primary)
#	material = $Bulb.get_surface_material(0)
#	material.set_shader_param("Color", secondary)
	
# TODO: Automatically size the width?
# TODO: 
