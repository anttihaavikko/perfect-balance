extends Node

onready var request = $HTTPRequest

var base_url := "https://games.sahaqiel.com"
var game_name := "miz"
var page := 0
var per_page := 9

signal scores_loaded(data);

func _ready() -> void:
	load_scores()
	
func load_scores():
	var url = "%s/leaderboards/load-scores.php?amt=%d&p=%d&game=%s" % [base_url, per_page, page, game_name]
	request.connect("request_completed", self, "_got_scores")
	request.request(url)

func _got_scores(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error == OK:
		emit_signal("scores_loaded", json.result.scores)

