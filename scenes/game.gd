extends Node

var intro = preload("res://scenes/start_screen/start_screen.tscn")
var hud = preload("res://scenes/hud.tscn")
var level_1 = preload("res://michail/levels/level_1.tscn")
var level_2 = preload("res://michail/levels/level_2.tscn")
var level_3 = preload("res://michail/levels/level_3.tscn")
var level_4 = preload("res://michail/levels/level_4.tscn")
var levels_beat = 0

var current_level = null
var player = null
var hud_i = null


var LEVELS = {
	1: level_1,
	2: level_2,
	3: level_3,
	4: level_4,
}

func start_level_and_get_player(level_number: int) -> Player:
	var hud = get_node_or_null("HUD")
	if hud:
		hud.queue_free()
	
	var level = LEVELS.get(level_number).instantiate()
	current_level = level
	add_child(level)
	return level.get_player()

func initialize_hud(player: Player) -> void:
	var hud_layer = hud.instantiate()
	hud_i = hud_layer
	hud_layer.get_node("SoulBar").player_ref = player
	add_child(hud_layer)

func destroy_hud() -> void:
	hud_i.queue_free()


func next_level() -> void:
	levels_beat+=1
	var current_level_number = levels_beat 
	current_level.queue_free()
	if current_level_number >= LEVELS.keys().size():
		destroy_hud()
		start_intro()
	else:
		var next_level_number = levels_beat + 1
		destroy_hud()
		player = start_level_and_get_player(next_level_number)
		initialize_hud(player)


func respawn_player() -> void:
	var current_level_number = levels_beat + 1
	current_level.queue_free()
	destroy_hud()
	var player = start_level_and_get_player(current_level_number)
	initialize_hud(player)

func start_game() -> void:
	player = start_level_and_get_player(1)
	initialize_hud(player)

func start_intro() -> void:
	var intro_instance = intro.instantiate()
	add_child(intro_instance)


func _ready() -> void:
	GameEvents.connect("player_died", respawn_player)
	GameEvents.connect("start_game", start_game)
	GameEvents.connect("cultist_killed", next_level)
	start_intro()
