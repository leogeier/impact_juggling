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
	
	if collision != null:
		var dir = Vector2()
		var collider = collision.collider
		if collider.is_in_group("paddle"):
			dir = collider.reflection_dir
			print(dir)
		
		velocity = velocity.length() * dir
	else:
		velocity.y += gravity * delta
