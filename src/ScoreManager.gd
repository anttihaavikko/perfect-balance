extends Node

onready var http_req = $HTTPRequest

var base_url := "https://games.sahaqiel.com"
var game_name := "godot"
var per_page := 9

var player_name: String

signal scores_loaded(data)
	
func load_scores(page: int):
	var url = "%s/leaderboards/load-scores.php?amt=%d&p=%d&game=%s" % [base_url, per_page, page, game_name]
	http_req.connect("request_completed", self, "_got_scores")
	http_req.request(url)
	
func submit(score: int, level: int):
	var data := "";
	data += player_name
	data += "," + "n/a"
	data += "," + level as String
	data += "," + round(score) as String
	data += "," + Secrets.get_verification_number(player_name, score, level) as String
	data += "," + game_name;
	var url = "%s/leaderboards/save-score.php?str=%s" % [base_url, data]
	http_req.request(url)

func _got_scores(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error == OK:
		emit_signal("scores_loaded", json.result.scores)

