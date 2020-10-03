extends KinematicBody2D

export var gravity = 4.5
export var max_speed = 6
export var rot_speed = 0.05

var velocity = Vector2()
var rot_dir = 0

func _ready():
	randomize()
	
	var ball_sprites = $BallSprites.get_children()
	ball_sprites[randi() % ball_sprites.size()].visible = true

func reflect(dir, damp):
	velocity = min(velocity.length() * damp, max_speed) * dir
	
	if rot_dir == 0:
		if randi() % 2 == 0:
			rot_dir = 1
		else:
			rot_dir = -1
	rot_dir *= -1

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	
	rotation += rot_dir * rot_speed
	
	if collision != null \
	   and collision.collider.is_in_group("reflectable"):
		var dir = collision.collider.get_reflection_dir(velocity.normalized())
		var damp = collision.collider.get_damp()
		reflect(dir, damp)
		
		if damp > 1:
			ScoreTracker.add_score(10)
	else:
		velocity.y += gravity * delta
