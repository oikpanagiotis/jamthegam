extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Globals.player_scene.insantiate()	
	player.global_position = $PlayerSpawnPoint.global_position
	add_child(player)

	
