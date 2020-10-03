extends KinematicBody2D

export var max_speed = 700;

var velocity = Vector2()

func get_reflection_dir(_dir):
	var dir = Vector2(0, 1).rotated($DirArrow.rotation)
	dir *= -1
	return dir

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = max_speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -max_speed
	else:
		velocity.x = 0
	
	move_and_collide(velocity * delta)
