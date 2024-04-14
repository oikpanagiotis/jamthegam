extends Node2D


func _ready() -> void:
	if not OS.is_debug_build():
		$Indicator.visible = false
