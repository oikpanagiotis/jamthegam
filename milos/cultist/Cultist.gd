extends Node2D

@onready var anim_player:= $AnimationPlayer
@onready var area:= $Area2D

var has_been_caught = false
var time_for_next_level = 30
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _proccess(delta):
	if has_been_caught && time_for_next_level>0:
		time_for_next_level -=1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if time_for_next_level == 0 :
		GameEvents.emit_signal("cultist_kill")	
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player"):
			if not has_been_caught:
				anim_player.play("idle")
			else:
				hide()
				get_parent().get_parent().next_level()


func _on_animation_player_animation_finished(anim_name):
	has_been_caught = true 
	
