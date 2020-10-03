extends Node2D

export var speed = 700;

func _ready():
	pass

func _process(delta):
	var pos_delta = speed * delta;
	if Input.is_action_pressed("ui_right"):
		position.x += pos_delta;
	elif Input.is_action_pressed("ui_left"):
		position.x -= pos_delta;
