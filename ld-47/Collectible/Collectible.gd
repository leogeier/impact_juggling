extends Area2D

var value

var possible_values = [20, 50, 100]

func collected(ball):
	if !ball.is_in_group("ball"):
		return
	
	ScoreTracker.add_score(value)
	self.queue_free()
	print("collected ", value)

func _ready():
	randomize()
	value = possible_values[randi() % possible_values.size()]
	self.connect("body_entered", self, "collected")

