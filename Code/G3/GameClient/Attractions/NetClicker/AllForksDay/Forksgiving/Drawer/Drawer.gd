extends Area2D
class_name Drawer

onready var SPRITE = $Sprite
export var speed: float = 50.0
signal landed

var has_prongs_up: bool = true # Start with the oriented up or down?
var valid_catch: bool = false # Does the tray have the same orientation as the Fork?

func _ready():
	if randi() % 2:
		has_prongs_up = false
		SPRITE.flip_v = true
	
func _process(delta_time):
	position.x += speed * delta_time

#func CheckValidCatch():
#	if valid_catch:
#		# TODO: Sever verification.
#		# rpd_id(1, "Tell the server who got forked and who got dropped.
#		emit_signal("landed")
#		print("Tell the GameServer that the player got a point.")


func _on_Drawer_area_entered(other_area):
	#print("Entered")
	if other_area is Fork:
		if other_area.has_prongs_up == has_prongs_up:
			valid_catch = true
			emit_signal("landed")
			# TODO: Just for now.
			other_area.queue_free() # Kill Fork.
			queue_free() # Kill Drawer.
		else:
			valid_catch = false
			other_area.queue_free() # Kill Fork.
