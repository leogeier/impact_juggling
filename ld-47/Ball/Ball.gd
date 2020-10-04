extends KinematicBody2D

export var gravity = 4.5
export var max_speed = 5.8
export var rot_speed = 0.05
export var min_paddle_velocity = 3
export var can_move = false

var velocity = Vector2()
var rot_dir = 0

var ScorePopup = preload("res://ScorePopup/ScorePopup.tscn")

func _ready():
	randomize()
	
	var ball_sprites = $BallSprites.get_children()
	ball_sprites[randi() % ball_sprites.size()].visible = true

func reflect(dir, damp, is_paddle):
	var speed
	if is_paddle:
		speed = clamp(velocity.length() * damp, min_paddle_velocity, max_speed)
	else:
		speed = min(velocity.length() * damp, max_speed)
	velocity = speed * dir
	
	if rot_dir == 0:
		if randi() % 2 == 0:
			rot_dir = 1
		else:
			rot_dir = -1
	rot_dir *= -1

func _physics_process(delta):
	if !can_move:
		return
	
	var collision = move_and_collide(velocity)
	
	rotation += rot_dir * rot_speed
	
	if collision != null \
	   and collision.collider.is_in_group("reflectable"):
		var dir = collision.collider.get_reflection_dir(velocity.normalized())
		var damp = collision.collider.get_damp()
		var collided_with_paddle = collision.collider.is_in_group("paddle")
		reflect(dir, damp, collided_with_paddle)
		
		if damp > 1:
			ScoreTracker.add_score(10)
			var popup = ScorePopup.instance()
			get_tree().get_root().add_child(popup)
			popup.launch(10, position, Vector2(0, -1).rotated(rand_range(-.3, .3)))
			
		if collided_with_paddle:
			Screenshake.start(.1, 3)
			if velocity.length() < min_paddle_velocity and damp > 1:
				velocity = velocity.normalized() * min_paddle_velocity
	else:
		velocity.y += gravity * delta
