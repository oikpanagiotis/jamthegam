extends CharacterBody2D

var player_ref: CharacterBody2D = null
var seen := false

var projectile_scn = preload("res://panos/projectile.tscn")

func attack(direction: Vector2):
	var projectile = projectile_scn.instantiate()
	const speed = 400
	projectile.fly_towards(direction, speed)
	get_parent().add_child(projectile)

func on_player_seen(player: CharacterBody2D) -> void:
	player_ref = player
	var player_pos = player.global_transform.origin
	print("I SEE YOU ({0}, {1})".format(player_pos.x, player_pos.y))


func _physics_process(delta) -> void:
	if seen and player_ref != null:
		
		pass
