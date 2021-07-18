extends Spatial
class_name Maze

# Struct?
class Cell:
	var x: int
	var y: int
	var visited: bool = false

		
export var ColumnCount: int = 5
export var RowCount: int = 5


var cell_list: Array 							# Main list that holds the cells.
var current_cell: int = 0


# Only needed for [F6]
func _ready():
	Init(ColumnCount, RowCount)
	
# Initialize
func Init(maze_width: int, maze_height: int) -> void:

	var cells_visited: int = 0
	var start_column: int = randi() % maze_height 	# 0 - 4 inclusive.
	var start_row: int = randi() % maze_width 		# 0 - 4 inclusive.
	
	# Fill the cell array with new Cells.
	for y in maze_height:
		for x in maze_width:
			var cell = Cell.new()
			cell.x = x
			cell.y = y
			cell_list.append(cell)
			
	#print("Cell List Size: %s" % [cell_list.size()])
	
	
	var size: int = cell_list.size()
	
	for each_cell in cell_list:
		print("X: %s, Y: %s" % [each_cell.x, each_cell.y])
	
	# Find all the neighbours.	
#	while cells_visited < size:
#		var current_cell: Cell = cell_list[(column_count - 1) * (row_count - 1)]
#
#		print(current_cell.x)
#		cell.x = start_row
#		cell.y = start_column
#
#		# Look for neighbours and push them to the neighbours array.
#		var neighbors: Array
#
#		# Look West.
#		if cell.x - 1 > 0:
#			var x: int = cell.x - 1
#			var y: int = Cell.y
#			neighbors.append(cell)
#
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


		
