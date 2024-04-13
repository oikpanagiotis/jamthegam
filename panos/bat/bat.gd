extends CharacterBody2D

var player_ref: CharacterBody2D = null
var seen := false


func on_player_seen(player: CharacterBody2D) -> void:
	player_ref = player
	var player_pos = player.global_transform.origin
	print("I SEE YOU ({0}, {1})".format(player_pos.x, player_pos.y))


func _physics_process(delta) -> void:
	pass
