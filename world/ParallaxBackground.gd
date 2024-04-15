extends ParallaxBackground

func _ready():
	for bg in get_children():
		var current_motion_scale = bg.motion_scale
		bg.motion_scale = Vector2(current_motion_scale.x, 0.02)
