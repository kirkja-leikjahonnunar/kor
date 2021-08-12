extends Spatial
class_name Room

var x: int = 0
var y: int = 0
var visited: bool = false
var neighbours: Array = []
	
func AddNeighbour(room: Room) -> void:
	neighbours.append(room)

func Visited(wall_to_drop: Area):
	pass
