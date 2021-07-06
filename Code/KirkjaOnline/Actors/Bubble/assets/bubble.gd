extends Spatial
class_name Bubble


var speed: float = 1 # m/s

func _process(delta_time: float) -> void:
	translate(Vector3.UP * speed * delta_time)
