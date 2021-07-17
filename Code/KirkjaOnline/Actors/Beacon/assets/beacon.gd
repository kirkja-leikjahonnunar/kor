extends Spatial
class_name Beacon

# Member variables.
export var lifetime: float = 4.0


func Init(primary: Color, secondary: Color) -> Beacon:
	var material: Material = $Pivot/Post.get_surface_material(0)
	material.set_shader_param("Color", primary)
	material = $Pivot/Post/Bulb.get_surface_material(0)
	material.set_shader_param("Color", secondary)
	
	var animations = $AnimationPlayer.get_animation_list()
	var rand_anim = rand_range(0, animations.size())
	$AnimationPlayer.play(animations[rand_anim])
	return self


func _on_Timer_timeout() -> void:
	queue_free()
