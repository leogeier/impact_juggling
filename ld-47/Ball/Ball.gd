extends KinematicBody2D

export var gravity = 9
var velocity = Vector2()

func _ready():
	pass

func reflect(dir):
	velocity = velocity.length() * dir
	print(dir)

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	
	if collision != null \
	   and collision.collider.is_in_group("reflectable"):
		var dir = collision.collider.get_reflection_dir(velocity.normalized())
		velocity = velocity.length() * dir
	else:
		velocity.y += gravity * delta
