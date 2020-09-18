extends Node2D

onready var leaderboard_names = $MainCanvas/Names
onready var leaderboard_scores = $MainCanvas/Scores

onready var flag_texture: Texture

onready var score_manager := $"/root/ScoreManager"

onready var next := $MainCanvas/NextPage
onready var prev := $MainCanvas/PrevPage

var flags = []
var page = 0

func _ready() -> void:
	next.hide()
	prev.hide()
	score_manager.connect("scores_loaded", self, "_on_ScoreManager_scores_loaded")
	score_manager.load_scores(page)
	
	flag_texture = load("res://assets/sprites/flags.png")
	
	for i in range(9):
		flags.append(get_node("MainCanvas/Flags/Flag%d" % (i + 1)))
		
func _on_NextPage_clicked() -> void:
	page += 1
	score_manager.load_scores(page)

func _on_PrevPage_clicked() -> void:
	page -= 1
	score_manager.load_scores(page)

func _on_ScoreManager_scores_loaded(scores) -> void:
	leaderboard_names.text = ""
	leaderboard_scores.text = ""
	
	for flag in flags:
		flag.hide()
	
	for entry in scores:
		leaderboard_names.text += "%d. %s\n" % [entry.position, entry.name]
		leaderboard_scores.text += "%s\n" % [entry.score]
		var at = AtlasTexture.new()
		at.set_atlas(flag_texture)
		var off = get_flag_pos(entry.locale)
		at.region = Rect2(off.x,off.y, 32, 32)
		var flag = flags[entry.position - 1 - page * 9]
		flag.texture = at;
		flag.show()
		
	if scores.size() >= 9:
		next.show()
	else:
		next.hide()
		
	if page == 0:
		prev.hide()
	else:
		prev.show()
		
static func get_flag_pos(country: String) -> Vector2:
	if country == "bj":
		return Vector2(256,32)
	if country == "tm":
		return Vector2(160,416)
	if country == "eg":
		return Vector2(384,96)
	if country == "tv":
		return Vector2(320,416)
	if country == "kz":
		return Vector2(320,224)
	if country == "lk":
		return Vector2(0,256)
	if country == "ai":
		return Vector2(128,0)
	if country == "dj":
		return Vector2(160,96)
	if country == "va":
		return Vector2(96,448)
	if country == "gy":
		return Vector2(288,160)
	if country == "fi":
		return Vector2(64,128)
	if country == "ne":
		return Vector2(0,320)
	if country == "jp":
		return Vector2(448,192)
	if country == "cv":
		return Vector2(32,96)
	if country == "nz":
		return Vector2(224,320)
	if country == "pa":
		return Vector2(288,320)
	if country == "mn":
		return Vector2(32,288)
	if country == "dm":
		return Vector2(224,96)
	if country == "bh":
		return Vector2(192,32)
	if country == "de":
		return Vector2(128,96)
	if country == "ki":
		return Vector2(96,224)
	if country == "nl":
		return Vector2(96,320)
	if country == "ye":
		return Vector2(352,448)
	if country == "it":
		return Vector2(288,192)
	if country == "lb":
		return Vector2(384,224)
	if country == "ru":
		return Vector2(320,352)
	if country == "zm":
		return Vector2(416,448)
	if country == "mm":
		return Vector2(0,288)
	if country == "in":
		return Vector2(160,192)
	if country == "fo":
		return Vector2(160,128)
	if country == "cd":
		return Vector2(128,64)
	if country == "ve":
		return Vector2(160,448)
	if country == "qa":
		return Vector2(192,352)
	if country == "gi":
		return Vector2(448,128)
	if country == "mr":
		return Vector2(128,288)
	if country == "gg":
		return Vector2(384,128)
	if country == "do":
		return Vector2(256,96)
	if country == "sk":
		return Vector2(128,384)
	if country == "bz":
		return Vector2(64,64)
	if country == "se":
		return Vector2(32,384)
	if country == "uz":
		return Vector2(64,448)
	if country == "rw":
		return Vector2(352,352)
	if country == "tt":
		return Vector2(288,416)
	if country == "ma":
		return Vector2(224,256)
	if country == "mh":
		return Vector2(384,256)
	if country == "at":
		return Vector2(352,0)
	if country == "om":
		return Vector2(256,320)
	if country == "fj":
		return Vector2(96,128)
	if country == "bs":
		return Vector2(416,32)
	if country == "pf":
		return Vector2(352,320)
	if country == "gm":
		return Vector2(32,160)
	if country == "sz":
		return Vector2(416,384)
	if country == "ga":
		return Vector2(224,128)
	if country == "lu":
		return Vector2(128,256)
	if country == "np":
		return Vector2(160,320)
	if country == "bg":
		return Vector2(160,32)
	if country == "pr":
		return Vector2(32,352)
	if country == "be":
		return Vector2(96,32)
	if country == "sg":
		return Vector2(64,384)
	if country == "ls":
		return Vector2(64,256)
	if country == "pt":
		return Vector2(96,352)
	if country == "am":
		return Vector2(192,0)
	if country == "to":
		return Vector2(224,416)
	if country == "je":
		return Vector2(352,192)
	if country == "ee":
		return Vector2(352,96)
	if country == "nc":
		return Vector2(448,288)
	if country == "vn":
		return Vector2(256,448)
	if country == "gw":
		return Vector2(256,160)
	if country == "hu":
		return Vector2(448,160)
	if country == "md":
		return Vector2(288,256)
	if country == "ci":
		return Vector2(256,64)
	if country == "jm":
		return Vector2(384,192)
	if country == "gr":
		return Vector2(160,160)
	if country == "ml":
		return Vector2(448,256)
	if country == "km":
		return Vector2(128,224)
	if country == "vi":
		return Vector2(224,448)
	if country == "ps":
		return Vector2(64,352)
	if country == "bo":
		return Vector2(352,32)
	if country == "zw":
		return Vector2(448,448)
	if country == "sn":
		return Vector2(224,384)
	if country == "mx":
		return Vector2(320,288)
	if country == "uy":
		return Vector2(32,448)
	if country == "vu":
		return Vector2(288,448)
	if country == "ni":
		return Vector2(64,320)
	if country == "ch":
		return Vector2(224,64)
	if country == "ag":
		return Vector2(96,0)
	if country == "sd":
		return Vector2(0,384)
	if country == "bw":
		return Vector2(0,64)
	if country == "us":
		return Vector2(0,448)
	if country == "ph":
		return Vector2(416,320)
	if country == "lc":
		return Vector2(416,224)
	if country == "is":
		return Vector2(256,192)
	if country == "ws":
		return Vector2(320,448)
	if country == "ly":
		return Vector2(192,256)
	if country == "gn":
		return Vector2(64,160)
	if country == "gu":
		return Vector2(224,160)
	if country == "ke":
		return Vector2(0,224)
	if country == "hr":
		return Vector2(384,160)
	if country == "ge":
		return Vector2(320,128)
	if country == "hk":
		return Vector2(320,160)
	if country == "re":
		return Vector2(224,352)
	if country == "al":
		return Vector2(160,0)
	if country == "co":
		return Vector2(416,64)
	if country == "er":
		return Vector2(448,96)
	if country == "sy":
		return Vector2(384,384)
	if country == "ro":
		return Vector2(256,352)
	if country == "th":
		return Vector2(64,416)
	if country == "sl":
		return Vector2(160,384)
	if country == "nr":
		return Vector2(192,320)
	if country == "br":
		return Vector2(384,32)
	if country == "ec":
		return Vector2(320,96)
	if country == "kr":
		return Vector2(224,224)
	if country == "pg":
		return Vector2(384,320)
	if country == "mz":
		return Vector2(384,288)
	if country == "sa":
		return Vector2(384,352)
	if country == "gt":
		return Vector2(192,160)
	if country == "kg":
		return Vector2(32,224)
	if country == "bi":
		return Vector2(224,32)
	if country == "cu":
		return Vector2(0,96)
	if country == "tg":
		return Vector2(32,416)
	if country == "dz":
		return Vector2(288,96)
	if country == "bt":
		return Vector2(448,32)
	if country == "lr":
		return Vector2(32,256)
	if country == "rs":
		return Vector2(288,352)
	if country == "tw":
		return Vector2(352,416)
	if country == "aw":
		return Vector2(416,0)
	if country == "py":
		return Vector2(160,352)
	if country == "kh":
		return Vector2(64,224)
	if country == "gq":
		return Vector2(128,160)
	if country == "gh":
		return Vector2(416,128)
	if country == "st":
		return Vector2(320,384)
	if country == "tn":
		return Vector2(192,416)
	if country == "mv":
		return Vector2(256,288)
	if country == "ky":
		return Vector2(288,224)
	if country == "hn":
		return Vector2(352,160)
	if country == "fr":
		return Vector2(192,128)
	if country == "si":
		return Vector2(96,384)
	if country == "id":
		return Vector2(0,192)
	if country == "au":
		return Vector2(384,0)
	if country == "tr":
		return Vector2(256,416)
	if country == "my":
		return Vector2(352,288)
	if country == "lt":
		return Vector2(96,256)
	if country == "li":
		return Vector2(448,224)
	if country == "cg":
		return Vector2(192,64)
	if country == "by":
		return Vector2(32,64)
	if country == "bn":
		return Vector2(320,32)
	if country == "mg":
		return Vector2(352,256)
	if country == "fm":
		return Vector2(128,128)
	if country == "tz":
		return Vector2(384,416)
	if country == "sb":
		return Vector2(416,352)
	if country == "as":
		return Vector2(320,0)
	if country == "il":
		return Vector2(64,192)
	if country == "ng":
		return Vector2(32,320)
	if country == "mk":
		return Vector2(416,256)
	if country == "no":
		return Vector2(128,320)
	if country == "af":
		return Vector2(64,0)
	if country == "ua":
		return Vector2(416,416)
	if country == "sc":
		return Vector2(448,352)
	if country == "cf":
		return Vector2(160,64)
	if country == "ck":
		return Vector2(288,64)
	if country == "cr":
		return Vector2(448,64)
	if country == "kw":
		return Vector2(256,224)
	if country == "ae":
		return Vector2(32,0)
	if country == "iq":
		return Vector2(192,192)
	if country == "vc":
		return Vector2(128,448)
	if country == "gd":
		return Vector2(288,128)
	if country == "pw":
		return Vector2(128,352)
	if country == "me":
		return Vector2(320,256)
	if country == "ad":
		return Vector2(0,0)
	if country == "gb":
		return Vector2(256,128)
	if country == "ug":
		return Vector2(448,416)
	if country == "mo":
		return Vector2(64,288)
	if country == "kp":
		return Vector2(192,224)
	if country == "ba":
		return Vector2(0,32)
	if country == "cn":
		return Vector2(384,64)
	if country == "bf":
		return Vector2(128,32)
	if country == "eh":
		return Vector2(416,96)
	if country == "cy":
		return Vector2(64,96)
	if country == "ir":
		return Vector2(224,192)
	if country == "so":
		return Vector2(256,384)
	if country == "za":
		return Vector2(384,448)
	if country == "tl":
		return Vector2(128,416)
	if country == "es":
		return Vector2(0,128)
	if country == "tc":
		return Vector2(448,384)
	if country == "sm":
		return Vector2(192,384)
	if country == "jo":
		return Vector2(416,192)
	if country == "sr":
		return Vector2(288,384)
	if country == "ht":
		return Vector2(416,160)
	if country == "la":
		return Vector2(352,224)
	if country == "ie":
		return Vector2(32,192)
	if country == "mw":
		return Vector2(288,288)
	if country == "ar":
		return Vector2(288,0)
	if country == "gp":
		return Vector2(96,160)
	if country == "et":
		return Vector2(32,128)
	if country == "mq":
		return Vector2(96,288)
	if country == "mu":
		return Vector2(224,288)
	if country == "bd":
		return Vector2(64,32)
	if country == "bm":
		return Vector2(288,32)
	if country == "pk":
		return Vector2(448,320)
	if country == "gl":
		return Vector2(0,160)
	if country == "pl":
		return Vector2(0,352)
	if country == "cz":
		return Vector2(96,96)
	if country == "dk":
		return Vector2(192,96)
	if country == "mc":
		return Vector2(256,256)
	if country == "td":
		return Vector2(0,416)
	if country == "sv":
		return Vector2(352,384)
	if country == "an":
		return Vector2(224,0)
	if country == "pe":
		return Vector2(320,320)
	if country == "ms":
		return Vector2(160,288)
	if country == "bb":
		return Vector2(32,32)
	if country == "lv":
		return Vector2(160,256)
	if country == "cm":
		return Vector2(352,64)
	if country == "im":
		return Vector2(128,192)
	if country == "vg":
		return Vector2(192,448)
	if country == "az":
		return Vector2(448,0)
	if country == "mt":
		return Vector2(192,288)
	if country == "ca":
		return Vector2(96,64)
	if country == "tj":
		return Vector2(96,416)
	if country == "ao":
		return Vector2(256,0)
	if country == "cl":
		return Vector2(320,64)
	if country == "kn":
		return Vector2(160,224)
	if country == "na":
		return Vector2(416,288)
		
	return Vector2.ZERO
