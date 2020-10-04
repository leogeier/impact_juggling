extends Area2D

var value
var possible_values = [20, 50, 100]
var is_collectable = false

signal collected

func on_collected(ball):
	if !ball.is_in_group("ball") or !is_collectable:
		return
	
	ScoreTracker.add_score(value)
	emit_signal("collected")
	self.queue_free()
	print("collected ", value)

func _ready():
	randomize()
	value = possible_values[randi() % possible_values.size()]
	self.connect("body_entered", self, "on_collected")

func _process(delta):
	if !is_collectable:
		is_collectable = true
		visible = true
		for body in self.get_overlapping_bodies():
			if body.is_in_group("ball"):
				is_collectable = false
				visible = false
				break
		

