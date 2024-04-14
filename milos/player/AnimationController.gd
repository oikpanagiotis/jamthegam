extends Node
@onready var player:Player 
@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
var dash_animation_finished = false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	if player.state != null:
		match player.state:
			Player.State.WALKING:
				if dash_animation_finished:
					animation_player.play("run")
			Player.State.DASHING:
				if dash_animation_finished:
					animation_player.play("dash")
			Player.State.IDLE:
				if dash_animation_finished:
					animation_player.play("idle")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dash":
		dash_animation_finished = true
		

func _on_animation_player_animation_started(anim_name):
	if anim_name == "dash":
		dash_animation_finished = false

