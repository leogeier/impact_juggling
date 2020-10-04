extends Node2D

signal life_lost

export var lives = 3

var hearts = []

func remove_life():
	lives -= 1
	emit_signal("life_lost")
	
	if lives > 0:
		hearts[lives].visible = false
		Screenshake.start(.1, 4)
		$LifeLostSound.play()
	else:
		print("Game Over")
		$GameOverSound.play()
	

func _ready():
	$BallDetector.connect("ball_entered", $BallSpawner, "queue_ball")
	$BallDetector.connect("ball_entered", self, "remove_life")
	ScoreTracker.reset_score()
	hearts = [$Hearts/Heart1, $Hearts/Heart2, $Hearts/Heart3]
	self.connect("life_lost", $DynamicBG, "on_life_lost")

func _process(delta):
	if Screenshake.active:
		position = Vector2(rand_range(-1,1),rand_range(-1,1)) * Screenshake.strength
	else:
		position = Vector2(0,0)
