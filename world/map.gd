extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Globals.player_scene.instantiate()
	player.global_position = $PlayerSpawnPoint.global_position
	add_child(player)

func get_player() -> Player:
	return $Player

func get_spawn() -> Node2D:
	return $PlayerSpawnPoint

func reset() -> void:
	for node in $Enemies.get_children():
		if node.is_in_group("agent"):
			node.reset()
