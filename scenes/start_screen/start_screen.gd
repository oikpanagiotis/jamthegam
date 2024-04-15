extends Control


func _input(event):
	if event.is_pressed():
		GameEvents.emit_signal("start_game")
		queue_free()

func _ready() -> void:
	pass # Replace with function body.
