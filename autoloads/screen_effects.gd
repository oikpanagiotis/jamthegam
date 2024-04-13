extends Node



func frame_freeze(time_scale: float, duration: float) -> void:
	Engine.time_scale = time_scale
	#yield(get_tree().create_timer(duration))