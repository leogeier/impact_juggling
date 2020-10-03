extends Area2D

signal ball_entered

func ball_entered(node):
	if !node.is_in_group("ball"):
		return
	
	node.queue_free()
	emit_signal("ball_entered")

func _ready():
	self.connect("body_entered", self, "ball_entered")
	
