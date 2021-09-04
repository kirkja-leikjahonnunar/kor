extends Area

export var world: String = "res://Worlds/Wammerjam/Wamerjam.tscn"


func _on_Portal_area_entered(area):
	get_tree().change_scene(world)
