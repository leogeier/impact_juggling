extends Node

var score = 0

signal score_changed

func reset_score():
	score = 0
	emit_signal("score_changed")

func add_score(val):
	score += val
	emit_signal("score_changed")
