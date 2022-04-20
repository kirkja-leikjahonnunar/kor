extends RayCast3D

@export var spray_image : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(is_colliding())
	
	if is_colliding() && Input.is_action_just_pressed("char_use1"):
		Spray()


func Spray():
	print ("Spray!")
	
	var decal = Decal.new()
	decal.texture_albedo = spray_image
	
	#print ("should be testarea: ", get_tree().root.get_node("TestArea").name)
	#get_tree().get_root FIXME !!! HOW!!??!?!?!
	
	get_tree().root.get_node("TestArea/Environment").add_child(decal)
	
	decal.global_transform.origin = get_collision_point()
	#get_collision_normal() -> must be the y axis
#	decal.global_transform.basis = Basis(global_transform.basis.x,
#										global_transform.basis.y,
#										global_transform.basis.z)
	
	decal.global_transform.basis = global_transform.basis
	
	
	#get_collision_normal()
