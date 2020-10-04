extends Node2D

func on_reveal():
	$Content.visible = true
	$RevealSound.play()

func _ready():
	$Content/Score.text = String(ScoreTracker.score)
	$RevealTimer.connect("timeout", self, "on_reveal")
