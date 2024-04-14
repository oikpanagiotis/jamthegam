extends Node

func frame_freeze(time_scale: float, duration: float) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration)

func controller_vibrate(intensity: float, duration: float) -> void:
	Input.start_joy_vibration(0, intensity, 0, duration)

func frame_freeze_long() -> void:
	frame_freeze(0.03, 0.3)

func frame_freeze_short() -> void:
	frame_freeze(0.03, 0.1)

func controller_vibrate_weak() -> void:
	controller_vibrate(0.3, 0.1)

func controller_vibrate_strong() -> void:
	controller_vibrate(0.6, 0.3)

func screen_shake(intensity: float, duration: float) -> void:
	pass
