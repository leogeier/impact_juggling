extends Node2D

export var speed = 700;

func add_ball(ball):
	$Area2D.connect("body_entered", self, "ball_collision")

func ball_collision(ball):
	var dir = Vector2(0, 1).rotated($DirArrow.rotation)
	dir *= -1
	ball.reflect(dir)

func _ready():
	pass

func _process(delta):
	var pos_delta = speed * delta;
	if Input.is_action_pressed("ui_right"):
		position.x += pos_delta;
	elif Input.is_action_pressed("ui_left"):
		position.x -= pos_delta;
