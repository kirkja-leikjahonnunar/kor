extends Spatial
class_name Maze

# Struct-like.
class Cell:
	var x: int
	var y: int
	var visited: bool = false
	var neighbours: Array = []

		
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
	var cells: Array = [] # Access the array thusly: cells[y * maze_width + x]
	var current_x: int = 0
	var current_y: int = 0
	
	var starting_x: int = randi() % maze_width # 0 - 4 inclusive.
	var starting_y: int = randi() % maze_height # 0 - 4 inclusive.
	
	# Fill the array with default Cells.
	for y in maze_height:
		for x in maze_width:
			var cell = Cell.new()
			cell.x = x
			cell.y = y
			cell.visited = false
			cells.append(cell)
			
	print(cells.size())
	
	
	# Find all neighbours to a particular cell.
	for cell in cells:
		
		# Left Neighbour?
		if cell.x - 1 >= 0:
			cell.neighbours.append(cells[(cell.y) * maze_width + cell.x - 1])
		
		# Right Neighbour?
		if cell.x + 1 < maze_width:
			cell.neighbours.append(cells[(cell.y) * maze_width + cell.x + 1])
			
		# Up Neighbour?
		if cell.y - 1 >= 0:
			cell.neighbours.append(cells[(cell.y - 1) * maze_width + cell.x])
	
		# Down Neighbour?
		if cell.y + 1 < maze_height:
			cell.neighbours.append(cells[(cell.y + 1) * maze_width + cell.x])
	
		print(cell.neighbours.size())
	
	
