extends Node2D

export var rot_speed = 3
export var offset = 5

var orig_pos
var dir = Vector2(0, 1)

func on_play():
	get_tree().change_scene("res://Main/Main.tscn")

func on_highscore():
	get_tree().change_scene("res://HighscoreList/HighscoreList.tscn")

func _ready():
	ScoreTracker.reset_score()
	orig_pos = $title.position
	$Play.connect("button_down", self, "on_play")
	$Highscores.connect("button_down", self, "on_highscore")

func _process(delta):
	dir = dir.rotated(rot_speed * delta)
	$title.position = orig_pos + dir * offset
	
	$title.rotation = sin(OS.get_ticks_msec() * 0.005) * 0.05
