extends StaticBody2D

enum Axis {x, y}
export(Axis) var normal

func get_reflection_dir(dir):
	if normal == Axis.x:
		dir.x *= -1
	else:
		dir.y *= -1
	return dir

func get_damp():
	return 1

func _ready():
	pass
