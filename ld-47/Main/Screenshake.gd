extends Node

var strength
var timer
var active = false

func on_timeout():
	active = false

func start(duration, new_strength):
	timer.wait_time = duration
	timer.start()
	active = true
	strength = new_strength

func _ready():
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "on_timeout")
