extends Node2D

func _ready():
	$BallDetector.connect("ball_entered", $BallSpawner, "queue_ball")
	ScoreTracker.reset_score()
