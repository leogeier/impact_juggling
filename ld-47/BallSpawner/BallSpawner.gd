extends Node2D

export var blink_count = 6

var queued_balls = 0
var blinks_left
var cur_ball
var main
var is_active = true

var Ball = preload("res://Ball/Ball.tscn")

func queue_ball():
	queued_balls += 1
	attempt_ball_spawn()

func attempt_ball_spawn():
	if queued_balls > 0 and $SpawnPauseTimer.is_stopped() and is_active:
		spawn_ball()
		queued_balls -= 1
		$SpawnPauseTimer.start()

func spawn_ball():
	cur_ball = Ball.instance()
	cur_ball.position = position
	main.connect("game_over", cur_ball, "on_game_over")
	get_tree().get_root().add_child(cur_ball)
	
	blinks_left = blink_count
	$BlinkSound.play()
	$BlinkTimer.start()

func blink():
	if !is_active:
		return
	
	if blinks_left > 0:
		if blinks_left % 2 == 1:
			$BlinkSound.play()
		blinks_left -= 1
		cur_ball.visible = !cur_ball.visible
		$BlinkTimer.start()
	else:
		cur_ball.can_move = true

func on_game_over():
	is_active = false

func _ready():
	$SpawnPauseTimer.connect("timeout", self, "attempt_ball_spawn")
	$BlinkTimer.connect("timeout", self, "blink")
	for timer in $BallAddTimers.get_children():
		timer.connect("timeout", self, "queue_ball")
	main = get_tree().get_nodes_in_group("main")[0]
	main.connect("game_over", self, "on_game_over")
