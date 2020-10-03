extends Node2D

func update_score():
	$Label.text = String(ScoreTracker.score)

func _ready():
	ScoreTracker.connect("score_changed", self, "update_score")
	update_score()
