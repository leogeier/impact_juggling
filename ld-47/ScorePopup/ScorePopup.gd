extends Node2D

var min_rot_speed = 15
var max_rot_speed = 30
var rot_speed

var dist = 50
var dir


func launch(val, pos, new_dir = null):
	$Label.text = String(val)
	if new_dir != null:
		dir = new_dir
	
	position = pos
	var new_pos = pos + dir * dist
	
	$PosTween.interpolate_property(self, "position", position, new_pos, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$PosTween.start()
	$ScaleTween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(), 1.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$ScaleTween.start()
	#$Timer.start()

func start_scaledown():
	pass

func finish():
	self.queue_free()

func _ready():
	randomize()
	rot_speed = rand_range(min_rot_speed, max_rot_speed)
	if randi() % 2 == 0:
		rot_speed *= -1
	dir = Vector2(1, 0).rotated(rand_range(0, 2 * PI))
	
	$Timer.connect("timeout", self, "start_scaledown")
	$ScaleTween.connect("tween_all_completed", self, "finish")

func _process(delta):
	rotation_degrees += rot_speed * delta
	#position += dir * speed * delta
