extends Control

var finished_animation = false

func _input(event):
	if event.is_pressed() and finished_animation:
		GameEvents.emit_signal("start_game")
		queue_free()

func _ready() -> void:
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Intro":
		finished_animation = true
