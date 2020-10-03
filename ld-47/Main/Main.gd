extends Node2D

export var lives = 3

func remove_life():
	lives -= 1
	if lives == 0:
		print("Game Over")

func _ready():
	$BallDetector.connect("ball_entered", $BallSpawner, "queue_ball")
	$BallDetector.connect("ball_entered", self, "remove_life")
	ScoreTracker.reset_score()
