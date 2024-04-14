extends Area2D

var direction := Vector2.ZERO
var speed := 0

func fly_towards(dir: Vector2, in_speed: float) -> void:
	direction = dir
	speed = in_speed


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("player_died", "got_hit")
		queue_free()
