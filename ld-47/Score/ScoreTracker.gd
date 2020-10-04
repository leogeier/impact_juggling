extends Node

var score = 0
var id = null
var score_name = ""

signal score_changed

func reset_score():
	score = 0
	id = null
	score_name = ""
	emit_signal("score_changed")

func add_score(val):
	score += val
	emit_signal("score_changed")
