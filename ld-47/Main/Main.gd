extends Node2D

signal life_lost
signal game_over

export var lives = 3

var hearts = []

func remove_life():
	if !$InvincibilityTimer.is_stopped():
		return
	
	lives -= 1
	
	if lives > 0:
		hearts[lives].visible = false
		Screenshake.start(.1, 4)
		$LifeLostSound.play()
		$InvincibilityTimer.start()
		emit_signal("life_lost")
	else:
		hearts[0].visible = false
		$GameOverSound.play()
		
		emit_signal("game_over")

func drop_curtain():
	var new_curtain_pos = $Curtain.position
	new_curtain_pos.y = 200
	$CurtainTween.interpolate_property($Curtain, "position", $Curtain.position, new_curtain_pos, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$CurtainTween.start()

func change_to_game_over_screen():
	get_tree().change_scene("res://GameOverScreen/GameOverScreen.tscn")

func _ready():
	$BallDetector.connect("ball_entered", $BallSpawner, "queue_ball")
	$BallDetector.connect("ball_entered", self, "remove_life")
	ScoreTracker.reset_score()
	hearts = [$Hearts/Heart1, $Hearts/Heart2, $Hearts/Heart3]
	self.connect("life_lost", $DynamicBG, "on_life_lost")
	self.connect("game_over", $DynamicBG, "on_game_over")
	$GameOverSound.connect("finished", self, "drop_curtain")
	$CurtainTween.connect("tween_all_completed", self, "change_to_game_over_screen")

func _process(delta):
	if Screenshake.active:
		position = Vector2(rand_range(-1,1),rand_range(-1,1)) * Screenshake.strength
	else:
		position = Vector2(0,0)
