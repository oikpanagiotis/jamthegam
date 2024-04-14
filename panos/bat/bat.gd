extends CharacterBody2D

var player_ref: CharacterBody2D = null
var seen := false
var cooldown_left := 0

const COOLDOWN := 500


var projectile_scn = preload("res://panos/projectile.tscn")

func die() -> None:
	queue_free()

func attack(direction: Vector2):
	const SPEED = 700
	var projectile = projectile_scn.instantiate()
	projectile.global_position = global_position
	projectile.fly_towards(direction, SPEED)
	get_parent().add_child(projectile)

func on_player_seen(player: CharacterBody2D) -> void:
	player_ref = player
	seen = true

func _ready() -> void:
	if is_in_group("agent"):
		assert(has_method("die"), "All agents must implement die")

func _physics_process(delta) -> void:
	if seen and player_ref != null:
		cooldown_left -= delta
		
		var can_attack := false
		if cooldown_left <= 0:
			can_attack = true
			cooldown_left = COOLDOWN
		
		if can_attack:
			var player_dir = (player_ref.global_position - global_position).normalized()
			attack(player_dir)
		
