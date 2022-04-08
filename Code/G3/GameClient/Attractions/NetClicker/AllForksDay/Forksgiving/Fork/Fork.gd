extends Area2D
class_name Fork

onready var SPRITE = $Sprite
var fork_textures: Array

export var speed: float = 50.0
var has_prongs_up: bool = true
export var FORK_01: Texture

func _ready():
	# Load all the textures from the Fork > Assets folder.
	var path = "res://Attractions/NetClicker/AllForksDay/Forksgiving/Fork/Assets/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file_name: String = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and file_name.ends_with(".png"):
			fork_textures.append(load(path + "/" + file_name))
			
	
	dir.list_dir_end()
	for i in fork_textures.size():
		print(fork_textures[i])
	
	# TODO: Randomize Fork Texture and frame.
	#var rand = randi() % fork_textures.size()
	#SPRITE.texture = FORK_01
	
	# Fork orientation.
	if randi() % 2:
		has_prongs_up = false
		SPRITE.flip_v = true

func _process(delta_time: float):
	position.x -= speed * delta_time

func Flip():
	has_prongs_up = !has_prongs_up
	SPRITE.flip_v = !SPRITE.flip_v
	
func RandomProngsUp():
	# Random bool.
	has_prongs_up = true
	SPRITE.flip_v = false
	if randi() % 2:
		has_prongs_up = false
		SPRITE.flip_v = true


func _on_Fork_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == BUTTON_LEFT:
			Flip()
