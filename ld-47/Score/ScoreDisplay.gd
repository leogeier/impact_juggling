extends Node2D

func update_score():
	var text = String(ScoreTracker.score)
	if text.length() < 5:
		for i in range(5 - text.length()):
			text = "0" + text
	$Label.text = text

func _ready():
	ScoreTracker.connect("score_changed", self, "update_score")
	update_score()
