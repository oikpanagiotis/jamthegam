extends Area2D

var direction := Vector2.ZERO
var speed := 0

func fly_towards(dir: Vector2, speed: float) -> void:
	direction = dir
	speed = speed


func _physics_process(delta: float) -> void:
	position = direction * speed * delta
