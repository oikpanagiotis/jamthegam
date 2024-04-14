class_name Player extends CharacterBody2D

@export var SPEED = 1600
@export var MAX_SPEED = 400
@export var JUMP_VELOCITY = -400
@export var gravity_terminal_velocity = 600
@export var friction_floor = 2000
@export var friction_air = 2000
@export var gravity_muliplier = 4
@export var wall_ride_speed = 1600
@export var coyote_frames = 5
@export var dash_cooldown_in_frames = 0
@export var dash_grace_in_frames = 5
@export var wall_frames = 5

@onready var sprite = $Sprite2D
@onready var left_wall_raycast_lower = $CollisionShape2D/LeftWallRayCastLower
@onready var right_wall_raycast_lower = $CollisionShape2D/RightWallRayCastLower
@onready var left_wall_raycast_upper = $CollisionShape2D/LeftWallRayCastUpper
@onready var right_wall_raycast_upper = $CollisionShape2D/RightWallRayCastUpper
@onready var dash_detection_area = $DashDetectionArea
@onready var animation_player = $AnimationPlayer

@onready var dash_audio_player = $DashAudioPlayer

var is_dashing = false
var last_direction = 1
var dash_animation_finished = false
var input = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_muliplier
var coyote_timer = 0
var target = null
var arrow_scene = preload("res://milos/arrow/arrow.tscn")
var current_arrow :Node2D = arrow_scene.instantiate()
var dash_velocity = Vector2.ZERO

var dash_sound = [
	preload("res://sfx/attack/attack2.wav"),
	preload("res://sfx/attack/attack3.wav")]
var last_played_dash_sound = 0

func play_dash_sound() -> void:
	var sound = dash_sound[last_played_dash_sound]
	last_played_dash_sound += 1
	last_played_dash_sound  =  last_played_dash_sound % len(dash_sound)
	dash_audio_player.stream = sound
	dash_audio_player.play()

func _process(delta):
	if dash_grace_in_frames >0:
		dash_grace_in_frames -=1
	if(!is_dashing && dash_cooldown_in_frames>0):
		dash_cooldown_in_frames -=1
	if is_on_floor():
		coyote_timer = coyote_frames 
	else:
		if coyote_timer > 0:
			coyote_timer -= 1

func _physics_process(delta):

	var current_target:Node2D = get_target()
	animate_arrow(current_target)
	target = current_target

	if can_dash():
		is_dashing = true 
		if  target.global_position.x - global_position.x < 0:
			sprite.flip_h = 1
		else:
			sprite.flip_h = 0
		animation_player.play("dash")
		dash_cooldown_in_frames = 15
		dash_velocity = (target.global_position - global_position).normalized()*(-JUMP_VELOCITY)

	if should_stop_dashing():
		current_target.die()
		is_dashing = false
		velocity = dash_velocity
		dash_grace_in_frames = 10
		
	if is_dashing:
		position = position.move_toward(target.global_position,15)
		velocity = Vector2.ZERO
	elif dash_grace_in_frames == 0:
		move(delta)
	move_and_slide()
	
func move(delta):
	var direction = Input.get_axis("left", "right")

	if not is_on_floor():
		if is_on_wall_only()&&is_falling()&&direction:
			velocity.y = wall_ride_speed * delta
		else:
			velocity.y += gravity * delta

	if direction:
		last_direction = direction
		if direction == -1:
			sprite.flip_h = 1
		else:
			sprite.flip_h = 0
		if dash_animation_finished:
			animation_player.play("run")

		if(abs(velocity.x + direction * SPEED * delta) < MAX_SPEED):
			velocity.x += direction * SPEED * delta
	else:
		if dash_animation_finished:
			animation_player.play("idle")
		if is_on_floor():
			if abs(velocity.x) > (friction_floor * delta):
				velocity.x -= velocity.normalized().x * (friction_floor * delta)
			else:
				velocity.x=0
		else:
			if abs(velocity.x) > (friction_air * delta):
				velocity.x -= velocity.normalized().x * (friction_air * delta)
			else:
				velocity.x=0

	# Handle jump
	if Input.is_action_just_pressed("jump") :
		if is_on_floor()||coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
		if !is_on_floor() &&(is_fully_on_left_wall() || is_fully_on_right_wall()):
			velocity.y = JUMP_VELOCITY
			if is_fully_on_left_wall():
				velocity.x = - JUMP_VELOCITY 
			elif is_fully_on_right_wall():
				velocity.x = JUMP_VELOCITY 

	#variable jump
	if Input.is_action_just_released("jump")&&!is_falling()&&(velocity.y < -300):
		velocity.y += 160
	#Trash code please fix
	velocity.y = clamp(velocity.y,-gravity_terminal_velocity*1000,gravity_terminal_velocity)
	velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED)

func animate_arrow(current_target):
	if current_target != null:
		if current_target!=target:
			if(target!= null):
				target.remove_child(current_arrow)
			current_target.add_child(current_arrow)
		current_arrow.global_rotation = get_angle_to(current_target.position)
	else:	
		if(target!= null):
			target.remove_child(current_arrow)

func get_target():
	var enemies_in_range = get_enemies_in_range()
	var target_to_return = null
	if enemies_in_range.size() >= 1:
		var min_distance = global_position.distance_to(enemies_in_range[0].global_position)
		target_to_return = enemies_in_range[0]
		for i in range(1,enemies_in_range.size(),1):
			if global_position.distance_to(enemies_in_range[i].global_position) < min_distance:
				target_to_return = enemies_in_range[i]
				min_distance = global_position.distance_to(enemies_in_range[i].global_position) < min_distance
	return target_to_return

func get_enemies_in_range():
	var enemies = []
	for body in dash_detection_area.get_overlapping_bodies():
		if body.is_in_group("agent"):
			enemies.append(body)

	return enemies

func get_enemies_in_range_directional():
	var enemies = []
	for body in dash_detection_area.get_overlapping_bodies():
		if body.is_in_group("agent"):
			if last_direction == 1:
				if body.global_position.x > global_position.x:
					enemies.append(body)
			else:
				if body.global_position.x < global_position.x:
					enemies.append(body)

	return enemies

func is_falling():
	return velocity.y > 0

func is_fully_on_right_wall():
	return right_wall_raycast_upper.is_colliding() && right_wall_raycast_lower.is_colliding()

func is_fully_on_left_wall():
	return left_wall_raycast_upper.is_colliding() && left_wall_raycast_upper.is_colliding()
	
func player_is_able_to_jump():
	return is_on_floor

func can_dash():
	return target != null && Input.is_action_just_pressed("attack") && dash_cooldown_in_frames==0
	
func should_stop_dashing():
	return target != null && global_position.distance_to(target.global_position) < 30 && is_dashing 


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dash":
		dash_animation_finished = true


func _on_animation_player_animation_started(anim_name):
		if anim_name == "dash":
			dash_animation_finished = false
