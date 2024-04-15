extends Camera2D

@export var focus_pont: Node2D
@export var speed: float

func _ready():
	assert(focus_pont != null, "Focus point must be set on player camera")


func _process(delta) -> void:
	var focus_point := focus_pont.global_position
	self.global_position.x = self.global_position.lerp(focus_point, delta * speed).x
	self.global_position.y = self.global_position.lerp(focus_point, delta * speed/10).y
