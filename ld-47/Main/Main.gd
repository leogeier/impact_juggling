extends Node2D

export var lives = 3

var hearts = []

func remove_life():
	lives -= 1
	hearts[lives].visible = false
	if lives == 0:
		print("Game Over")

func _ready():
	$BallDetector.connect("ball_entered", $BallSpawner, "queue_ball")
	$BallDetector.connect("ball_entered", self, "remove_life")
	ScoreTracker.reset_score()
	hearts = [$Hearts/Heart1, $Hearts/Heart2, $Hearts/Heart3]
