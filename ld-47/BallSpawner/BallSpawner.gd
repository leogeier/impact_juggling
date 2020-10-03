extends Node2D

var queued_balls = 2

var Ball = preload("res://Ball/Ball.tscn")

func queue_ball():
	queued_balls += 1
	attempt_ball_spawn()

func attempt_ball_spawn():
	if $SpawnPauseTimer.is_stopped():
		spawn_ball()
		queued_balls -= 1
	
	if queued_balls > 0:
		$SpawnPauseTimer.start()

func spawn_ball():
	var ball = Ball.instance()
	ball.position = position
	get_tree().get_root().add_child(ball)
	

func _ready():
	$SpawnPauseTimer.connect("timeout", self, "attempt_ball_spawn")
	for timer in $BallAddTimers.get_children():
		timer.connect("timeout", self, "queue_ball")
