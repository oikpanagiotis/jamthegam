extends Area2D

var direction := Vector2.ZERO
var speed := 0
@onready var sprite:= $Sprite2D

func fly_towards(dir: Vector2, in_speed: float) -> void:
	direction = dir
	speed = in_speed

	

func _ready():
	sprite.rotation = direction.angle()
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameEvents.emit_signal("player_died")
		queue_free()
