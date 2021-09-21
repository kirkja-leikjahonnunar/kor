extends KinematicBody2D

var speed = 1000 # Pixels / sec

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		move_and_slide(Vector2(1, 0) * speed)
	if Input.is_action_pressed("move_left"):
		move_and_slide(Vector2(-1, 0) * speed)
	if Input.is_action_pressed("move_forward"):
		move_and_slide(Vector2(0, -1) * speed)
	if Input.is_action_pressed("move_back"):
		move_and_slide(Vector2(1, 1) * speed)


func _on_KinematicBody2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouse:
		position = event.position
		#if event.is_pressed():
			#emit_signal("popped")
			#queue_free()			
	pass
