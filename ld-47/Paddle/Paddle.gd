extends StaticBody2D

export var speed = 700;

var reflection_dir setget , get_reflection_dir

func get_reflection_dir():
	var dir = Vector2(0, 1).rotated($DirArrow.rotation)
	dir *= -1
	return dir

func _ready():
	pass

func _physics_process(delta):
	var pos_delta = speed * delta;
	if Input.is_action_pressed("ui_right"):
		position.x += pos_delta;
	elif Input.is_action_pressed("ui_left"):
		position.x -= pos_delta;
