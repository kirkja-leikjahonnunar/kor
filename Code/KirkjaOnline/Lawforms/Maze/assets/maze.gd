extends Spatial
class_name Maze

const ROOM_PS: PackedScene = preload("res://Lawforms/Maze/assets/Room.tscn")

export var ColumnCount: int = 5
export var RowCount: int = 5


#------------------------------------------------------------------------------
# Only needed for [F6]
#------------------------------------------------------------------------------
func _ready():
	Init(ColumnCount, RowCount)


#------------------------------------------------------------------------------
# Initialize
#------------------------------------------------------------------------------
func Init(maze_width: int, maze_height: int) -> void:

	# Single array aproach.
	var rooms: Array = [] # Access the array thusly: rooms[y * maze_width + x]
	var visited: Array = []
	var current_x: int = 0
	var current_y: int = 0
	
	var starting_x: int = randi() % maze_width # 0 - 4 inclusive.
	var starting_y: int = randi() % maze_height # 0 - 4 inclusive.
	
	#-----------------------------------
	# Fill the array with default Cells.
	#-----------------------------------
	for y in maze_height:
		for x in maze_width:
			var room: Room = ROOM_PS.instance()
			room.x = x
			room.y = y
			room.visited = false
			room.translation = Vector3(x, 0, y)
			rooms.append(room)
			add_child(room)
			
	print(rooms.size())
	
	#------------------------------------------
	# Find all neighbours to a particular room.
	#------------------------------------------
	for room in rooms:
		if room is Room: # Cast to Cell.
			
			if room.x - 1 >= 0: # Look left.
				room.AddNeighbour(rooms[(room.y) * maze_width + room.x - 1])

			if room.x + 1 < maze_width: # Look right.
				room.AddNeighbour(rooms[(room.y) * maze_width + room.x + 1])

			if room.y - 1 >= 0: # Look up.
				room.AddNeighbour(rooms[(room.y - 1) * maze_width + room.x])

			if room.y + 1 < maze_height: # Look down.
				room.AddNeighbour(rooms[(room.y + 1) * maze_width + room.x])

			print(room.neighbours.size())

	#-------------------
	# Pathfinding Logic.
	#-------------------
	current_x = 0
	current_y = 0
	
	# TODO: Here tomorrow.
	for room in rooms:
		if room is Room:
			room.neighbours[0].Visited()
	
