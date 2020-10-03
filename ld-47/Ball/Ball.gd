extends KinematicBody2D

export var gravity = 9
export var max_speed = 12

var velocity = Vector2()

func _ready():
	pass

func reflect(dir, damp):
	velocity = min(velocity.length() * damp, max_speed) * dir

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	
	if collision != null \
	   and collision.collider.is_in_group("reflectable"):
		var dir = collision.collider.get_reflection_dir(velocity.normalized())
		var damp = collision.collider.get_damp()
		reflect(dir, damp)
	else:
		velocity.y += gravity * delta
	
	print(velocity.length())
