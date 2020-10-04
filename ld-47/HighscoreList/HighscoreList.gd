extends Node2D

var dot_count = 0

func update_dots():
	dot_count = (dot_count + 1) % 4
		
	var text = "Request"
	for i in range(dot_count):
		text += "."
	
	$RequestDesc.text = text

func on_top_scores_received(result, status_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		$SendingDotsTimer.stop()
		$RequestDesc.text = "Failed with " + String(result) + ", sorry :("
		return
	
	if status_code > 299:
		$SendingDotsTimer.stop()
		$RequestDesc.text = "Received " + String(status_code) + ", sorry :("
		return
	
	$RequestDesc.visible = false
	
	var top_scores = JSON.parse(body.get_string_from_utf8()).result
	
	var ranks_text = ""
	for i in range(top_scores.size()):
		ranks_text += String(i + 1) + ".\n"
	$Leaderboard/Ranks.text = ranks_text
	
	var names_text = ""
	var scores_text = ""
	for entry in top_scores:
		names_text += entry.name + "\n"
		scores_text += String(entry.score) + "\n"
	$Leaderboard/Names.text = names_text
	$Leaderboard/Scores.text = scores_text
	
	$Leaderboard.visible = true

func on_own_rank_received(result, status_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		$SendingDotsTimer.stop()
		$RequestDesc.text = "Failed with " + String(result) + ", sorry :("
		return
	
	if status_code > 299:
		$SendingDotsTimer.stop()
		$RequestDesc.text = "Received " + String(status_code) + ", sorry :("
		return
	
	$RequestDesc.visible = false
	
	var own_rank = int(JSON.parse(body.get_string_from_utf8()).result.rank)
	
	if own_rank <= 10:
		return
	
	$Own/OwnRank.text = String(own_rank) + "."
	$Own/OwnName.text = ScoreTracker.score_name
	$Own/OwnScore.text = String(ScoreTracker.score)
	
	$Own.visible = true

func on_main_menu():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")

func _ready():
	$SendingDotsTimer.connect("timeout", self, "update_dots")
	$TopScoresRequest.connect("request_completed", self, "on_top_scores_received")
	$OwnRankRequest.connect("request_completed", self, "on_own_rank_received")
	$MainMenu.connect("button_down", self, "on_main_menu")
	
	var top_scores_url = "http://localhost:3000/highscore?count=10"
	$TopScoresRequest.request(top_scores_url)
	
	if ScoreTracker.id != null:
		var own_score_url = "http://localhost:3000/rank?id=" + String(ScoreTracker.id)
		$OwnRankRequest.request(own_score_url)
