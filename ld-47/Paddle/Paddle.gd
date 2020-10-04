extends KinematicBody2D

export var max_speed = 300;
export var decrease_damp = 0.8
export var increase_damp = 1.2
export var paddle_throw_time = 0.2
export var rot_magn = 0.3

var icon_pos_y setget set_icon_pos_y
var icon_rot setget set_icon_rot

var velocity = Vector2()
var throw_offset = -20
var icon_orig_y
var orig_y

func set_icon_pos_y(val):
	$icon.position.y = val

func set_icon_rot(val):
	$icon.rotation = val

func get_reflection_dir(_dir):
	var dir = Vector2(0, 1).rotated($DirArrow.rotation)
	dir *= -1
	return dir

func get_damp():
	if $ThrowTimer.is_stopped():
		return decrease_damp
	else:
		return increase_damp

func throw_timer_end():
	pass

func _ready():
	$ThrowTimer.connect("timeout", self, "throw_timer_end")
	icon_orig_y = $icon.position.y
	orig_y = position.y
	$ThrowTimer.wait_time = paddle_throw_time

func _physics_process(delta):
	if Input.is_action_just_pressed("fire"):
		if $PauseTimer.is_stopped():
			$PauseTimer.start()
			var ball_detected = false
			for body in $BallDetectorArea.get_overlapping_bodies():
				if body.is_in_group("ball"):
					ball_detected = true
					break
			if !ball_detected:
				$ThrowSound.pitch_scale = rand_range(0.5, 2.5)
				$ThrowSound.play()
			
			$ThrowTimer.start();
			$ReturnTween.interpolate_property(self, "icon_pos_y", icon_orig_y + throw_offset, icon_orig_y, paddle_throw_time, Tween.TRANS_CIRC, Tween.EASE_OUT)
			$ReturnTween.start()
			
			$ReturnRotTween.interpolate_property(self, "icon_rot", rand_range(-1, 1) * rot_magn, 0, paddle_throw_time, Tween.TRANS_CIRC, Tween.EASE_OUT)
			$ReturnRotTween.start()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = max_speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -max_speed
	else:
		velocity.x = 0
	
	move_and_collide(velocity * delta)
	position.y = orig_y
