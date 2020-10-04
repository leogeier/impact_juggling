extends Node2D

var style = StyleBoxFlat.new()
var dot_count = 0

func on_reveal():
	$Content.visible = true
	$RevealSound.play()

func on_text_change(new_text):
	$Content/Submit.disabled = new_text == ""

func on_submit():
	$Content/SendingDesc.visible = true
	$Content/Submit.visible = false
	$SendingDotsTimer.start()
	
	var name = $Content/Name.text
	var score = String(ScoreTracker.score)
	var time = String(OS.get_unix_time())
	var secret = "change_me"
	var fingerprint = (name + score + time + secret).sha256_text()
	
	ScoreTracker.score_name = name
	
	var url = "http://localhost:3000/highscore?name=" + name + "&score=" + score + "&time=" + time + "&fingerprint=" + fingerprint
	$SendHighscore.request(url, PoolStringArray(), true, HTTPClient.METHOD_POST)

func on_sent_score(result, status_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		$SendingDotsTimer.stop()
		$Content/SendingDesc.text = "Failed with " + String(result) + ", sorry :("
		return
	
	if status_code > 299:
		$SendingDotsTimer.stop()
		$Content/SendingDesc.text = "Received " + String(status_code) + ", sorry :("
		return
	
	var result_json = JSON.parse(body.get_string_from_utf8())
	ScoreTracker.id = result_json.result.id
	
	get_tree().change_scene("res://HighscoreList/HighscoreList.tscn")

func on_main_menu():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")

func update_sending_dots():
	dot_count = (dot_count + 1) % 4
	
	var text = "Sending"
	for i in range(dot_count):
		text += "."
	
	$Content/SendingDesc.text = text

func _ready():
	randomize()
	
	$Content/Score.text = String(ScoreTracker.score)
	$RevealTimer.connect("timeout", self, "on_reveal")
	$Content/Name.connect("text_changed", self, "on_text_change")
	$Content/Submit.connect("button_down", self, "on_submit")
	$Content/MainMenu.connect("button_down", self, "on_main_menu")
	$SendingDotsTimer.connect("timeout", self, "update_sending_dots")
	$SendHighscore.connect("request_completed", self, "on_sent_score")
	
	$Content/Name.grab_focus()
	
	style.bg_color = (Color(0, 1, 1, 1))
	set("custom_styles/normal", style)
