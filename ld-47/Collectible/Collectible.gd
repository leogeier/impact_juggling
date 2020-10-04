extends Area2D

var value
var possible_values = [20, 50, 100]
var is_collectable = false

var ScorePopup = preload("res://ScorePopup/ScorePopup.tscn")

signal collected

func on_collected(ball):
	if !ball.is_in_group("ball") or !is_collectable:
		return
	
	ScoreTracker.add_score(value)
	Screenshake.start(0.2, 3)
	
	var popup = ScorePopup.instance()
	get_tree().get_root().add_child(popup)
	popup.launch(value, position, Vector2(0, 1).rotated(rand_range(-.5, .5)))
	
	emit_signal("collected")
	self.queue_free()
	

func _ready():
	randomize()
	value = possible_values[randi() % possible_values.size()]
	self.connect("body_entered", self, "on_collected")

func _process(delta):
	if !is_collectable:
		is_collectable = true
		visible = true
		for body in $FreeArea.get_overlapping_bodies():
			if body.is_in_group("ball"):
				is_collectable = false
				visible = false
				break
		

