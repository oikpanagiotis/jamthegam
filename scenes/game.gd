extends Node

var hud = preload("res://scenes/hud.tscn")
var level_1 = preload("res://world/map.tscn")

var levels_beat = 0

var current_level = null
var player = null

var LEVELS = {
	1: level_1,
}

func start_level_and_get_player(level_number: int) -> Player:
	var hud = get_node("HUD")
	if hud:
		hud.queue_free()
	
	var level = LEVELS.get(level_number).instantiate()
	current_level = level
	add_child(level)
	return level.get_player()

func initialize_hud(player: Player) -> void:
	var hud_layer = hud.instantiate()
	hud_layer.get_node("SoulBar").player_ref = player
	add_child(hud_layer)


func respawn_player() -> void:
	var hud = get_node("HUD")
	var soulbar = hud.get_child(0)
	soulbar.reset()
	current_level.reset()
	
	var spawn_position = current_level.get_spawn().global_position
	player.global_position = spawn_position

func _ready() -> void:
	GameEvents.connect("player_died", respawn_player)
	
	player = start_level_and_get_player(1)
	initialize_hud(player)

