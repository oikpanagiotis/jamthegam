extends CharacterBody2D

var player_ref: CharacterBody2D = null
var seen := false
var cooldown_left := 0

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@export var can_shoot_projectiles:bool = false
var flight_direction = 1
var flight_speed = 40
var direction_switch_limit = 15

var projectile_scn = preload("res://panos/projectile.tscn")

func die() -> void:
	GameEvents.emit_signal("minion_killed")
	$AudioStreamPlayer2D.play()
	#queue_free()

func attack(direction: Vector2):
	const SPEED = 300
	var projectile = projectile_scn.instantiate()
	projectile.global_position = global_position
	projectile.fly_towards(direction, SPEED)
	get_parent().add_child(projectile)

func on_player_seen(player: CharacterBody2D) -> void:
	player_ref = player
	seen = true

func _ready() -> void:
	animation_player.play("indle")
	if is_in_group("agent"):
		assert(has_method("die"), "All agents must implement die")

func _physics_process(delta) -> void:
	if abs(sprite.offset.y) > direction_switch_limit:
		flight_direction = -flight_direction
	sprite.offset.y +=flight_direction*delta*flight_speed

	if seen and player_ref != null:
		if player_ref.global_position.x > global_position.x:
			sprite.flip_h=1
		else:
			sprite.flip_h=0
		if can_shoot_projectiles:
			cooldown_left -= delta
			
			var can_attack := false
			if cooldown_left <= 0:
				can_attack = true
				cooldown_left = randf_range ( 300, 700 )
			
			if can_attack:
				var player_dir = (player_ref.global_position - global_position).normalized()
				attack(player_dir)
				
