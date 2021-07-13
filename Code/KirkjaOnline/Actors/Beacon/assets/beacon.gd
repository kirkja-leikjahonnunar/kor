extends Spatial
class_name Beacon

# Node constants.
onready var PIVOT: Spatial = $Pivot
onready var POST: Spatial = $Pivot/Post
onready var BULB: Spatial = $Pivot/Post/Bulb
onready var ANIMATION: AnimationPlayer = $AnimationPlayer

# Member variables.
export var lifetime: float = 4.0


func Initialize(primary: Color, secondary: Color) -> void:
	var material: Material = POST.get_surface_material(0)
	material.set_shader_param("Color", primary)
	material = BULB.get_surface_material(0)
	material.set_shader_param("Color", secondary)
	
	var animations = $AnimationPlayer.get_animation_list()
	var rand = rand_range(0, animations.size())
	$AnimationPlayer.play(animations[rand])


func _on_Timer_timeout() -> void:
	queue_free()
