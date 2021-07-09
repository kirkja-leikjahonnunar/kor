#tool
extends Spatial
class_name Signpost

export var lifetime: float = 4.0

func Initialize(primary: Color, secondary: Color) -> void:
	var material: Material = $Post.get_surface_material(0)
	material.set_shader_param("Color", primary)
	material = $Bulb.get_surface_material(0)
	material.set_shader_param("Color", secondary)
	

func _on_Timer_timeout() -> void:
	queue_free()

