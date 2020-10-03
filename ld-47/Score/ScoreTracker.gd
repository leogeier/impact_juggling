extends Node

var score

signal score_changed

func reset_score():
	score = 0
	emit_signal("score_changed")

func add_score(val):
	score += val
	emit_signal("score_changed")
