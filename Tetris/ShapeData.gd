extends Control

class_name ShapeData

var color:Color
var grid:Array
var coors:Array
var cells:GridContainer

func rotate_left():
	cells.get_parent().rotate(-PI / 2)
	_rotate_grid(1, -1)

func rotate_right():
	cells.get_parent().rotate(PI / 2)
	_rotate_grid(-1, 1)

func _rotate_grid(sign_of_x, sign_of_y):
	var rotated_grid = grid.duplicate(true)
	for x in coors:
		for y in coors:
			var x1 = coors.find(x)
			var y1 = coors.find(y)
			var x2 = coors.find(sign_of_y * y)
			var y2 = coors.find(sign_of_x * x)
			rotated_grid[y1][x1] = grid[y2][x2]
	grid = rotated_grid
