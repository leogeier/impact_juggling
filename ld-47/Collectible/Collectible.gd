extends Area2D

var value
var possible_values = [20, 50, 100]
var is_collectable = false
var was_collected = false
var orig_pos
var offset_dir = Vector2(1, 0)
var offset_dist = 4
var rot_speed = 0.05

var ScorePopup = preload("res://ScorePopup/ScorePopup.tscn")

signal collected
signal not_collected

func on_collected(ball):
	if !ball.is_in_group("ball") or !is_collectable or was_collected:
		return
	
	ScoreTracker.add_score(value)
	Screenshake.start(0.2, 3)
	
	var popup = ScorePopup.instance()
	get_tree().get_root().add_child(popup)
	popup.launch(value, position, Vector2(0, 1).rotated(rand_range(-.5, .5)))
	$CollectSound.play()
	
	emit_signal("collected")
	was_collected = true
	visible = false

func not_collected():
	emit_signal("not_collected")
	Screenshake.start(1, 4)
	$LostSound.play()
	was_collected = true
	visible = false

func remove():
	self.queue_free()

func _ready():
	randomize()
	value = possible_values[randi() % possible_values.size()]
	$Visible/Label.text = String(value)
	self.connect("body_entered", self, "on_collected")
	$CollectSound.connect("finished", self, "remove")
	$LostSound.connect("finished", self, "remove")
	$Visible/AnimatedSprite.connect("animation_finished", self, "not_collected")
	orig_pos = $Visible.position
	if randi() % 2 == 0:
		rot_speed *= -1
	$Visible/AnimatedSprite.play()

func _process(delta):
	if !is_collectable:
		is_collectable = true
		visible = true
		for body in $FreeArea.get_overlapping_bodies():
			if body.is_in_group("ball"):
				is_collectable = false
				visible = false
				break
	
	offset_dir = offset_dir.rotated(rot_speed)
	$Visible.position = orig_pos + offset_dir * offset_dist

