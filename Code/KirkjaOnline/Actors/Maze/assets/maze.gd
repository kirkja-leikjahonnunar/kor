extends Spatial
class_name Maze

# Struct-like.
class Cell:
	var x: int
	var y: int
	var visited: bool = false
	var neighbours: Array = []
	
#	func Get2D(search_x, search_y):
#		print("X: %s, Y: %s" % [cells[3 * maze_width + 4].x, cells[3 * maze_width + 4].y])

		
export var ColumnCount: int = 5
export var RowCount: int = 5


#var cell_list: Array = [[]] # 2D Array? Yep. But not really extra helpful.

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
	
	#var current_cell: Cell = null
	
	var cells_visited: int = 0
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
	
	
	for cell in cells:
		#print("X: %s, Y: %s" % [cell.x, cell.y])
	
		# Left Neighbour?
		if cell.x - 1 > 0:
			cell.neighbours.append(cells[(cell.y) * maze_width + cell.x - 1])
		
		# Right Neighbour?
		if cell.x + 1 < maze_width - 1:
			cell.neighbours.append(cells[(cell.y) * maze_width + cell.x + 1])
			
		# Top Neighbour?
		if cell.y - 1 > 0:
			cell.neighbours.append(cells[(cell.y - 1) * maze_width + cell.x])
	
		# Top Neighbour?
		if cell.y + 1 < maze_height - 1:
			cell.neighbours.append(cells[(cell.y + 1) * maze_width + cell.x])
	
		print(cell.neighbours)
	
	# Size the array and fill the cell array with new Cells.
#	for x in maze_width:
#		cells.resize(maze_width)
#		for y in maze_height:
#			cells[x].resize(y)

	# Stuff a new array into each cells' elements.
#	for i in maze_width:
#		cells.append([])
#		for j in maze_height:
#			var cell = Cell.new()
#			cell.x = i
#			cell.y = j
#			cells[i].append(cell)
	
	
	# Fill the array with the default cells.
#	for y in maze_height:
#		for x in maze_width:
#			var cell = Cell.new()
#			cell.x = x
#			cell.y = y
#			cells[x][y] = cell

	#print("Cell List Size: %s" % [cell_list.size()])
	
	
	#var size: int = cells.size()
	

	
	# Find all the neighbours.	
	#while cells_visited < size:
#	var current_cell: Cell = cell_list[1][3] # TODO: Rando later.
#	print(current_cell.x)
#
#
#	var neighbors: Array
	
	# Look for neighbours and print.



#	# Look West.
#	if current_cell.x - 1 > 0:
#		var n_x: int = current_cell.x - 1
#		var n_y: int = current_cell.y
#		neighbors.append(cell_list[])

#		# Look North.
#		if cell.y - 1 > 0:
#			var x: int = cell.x
#			var y: int = Cell.y - 1
#			neighbors.append(cell)
#
#		# Look East.
#		if cell.x < row_count - 1:
#			var x: int = cell.x + 1
#			var y: int = Cell.y
#			neighbors.append(cell)
#
#		# Look South.
#		if cell.y < column_count - 1:
#			var x: int = cell.x
#			var y: int = Cell.y + 1
#			neighbors.append(cell)


		
