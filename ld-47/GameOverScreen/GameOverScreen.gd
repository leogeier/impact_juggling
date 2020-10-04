extends Node2D

var style = StyleBoxFlat.new()

func on_reveal():
	$Content.visible = true
	$RevealSound.play()

func on_text_change(new_text):
	$Content/Submit.disabled = new_text == ""

func _ready():
	randomize()
	
	$Content/Score.text = String(ScoreTracker.score)
	$RevealTimer.connect("timeout", self, "on_reveal")
	$Content/Name.connect("text_changed", self, "on_text_change")
	
	#var name = ""
	#for i in range(5):
	#	name = name + String(randi() % 10)
	#$Content/Name.text = name
	$Content/Name.grab_focus()
	
	style.bg_color = (Color(0, 1, 1, 1))
	set("custom_styles/normal", style)
