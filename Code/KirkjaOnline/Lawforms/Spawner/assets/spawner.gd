class_name Spawner
extends Spatial

export var limit_count: bool = false
export(int, 1, 100) var spawn_count: int = 1
export var spawn_interval: float = 1.5 setget set_spawn_interval
#export var autostart: bool = false setget set_autostart
export var lawform: PackedScene = null setget set_lawform

func set_spawn_interval(value):
	spawn_interval = value
	$Timer.wait_time = spawn_interval
	
#func set_autostart(value):
#	autostart = value
#	$Timer.autostart = autostart
	
func set_lawform(value):
	lawform = value

	
#------------------------------------------------------------------------------
# Ready()
#------------------------------------------------------------------------------
func _ready():
	_on_Timer_timeout()
	pass


#------------------------------------------------------------------------------
# Timer
#------------------------------------------------------------------------------
func _on_Timer_timeout():
	if lawform:
		if limit_count and spawn_count > 0:
			spawn_count -= 1
			
		var instance = lawform.instance()
		instance.transform = transform
		get_owner().call_deferred("add_child", instance) # add_child(instance).
		
		# Get rid of the spawner once all the actors get spawned.
		if spawn_count <= 0:
			queue_free()
			print("FINALLY FREE!")
	else:
		push_error("Null PS.")
		assert(false)
