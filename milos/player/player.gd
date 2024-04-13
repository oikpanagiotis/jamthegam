class_name Player extends CharacterBody2D

@export var SPEED = 1000
@export var MAX_SPEED = 1200
@export var JUMP_VELOCITY = -600.0
@export var friction_floor = 1000
@export var friction_air = 200
@export var gravity_muliplier = 2
@export var coyote_frames = 5
@export var wall_frames = 5
@onready var sprite = $Sprite2D
@onready var left_wall_raycast_lower = $CollisionShape2D/LeftWallRayCastLower
@onready var right_wall_raycast_lower = $CollisionShape2D/RightWallRayCastLower
@onready var left_wall_raycast_upper = $CollisionShape2D/LeftWallRayCastUpper
@onready var right_wall_raycast_upper = $CollisionShape2D/RightWallRayCastUpper

var input = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_muliplier
var coyote_timer = 0

func _process(delta):
	if is_on_floor():
		coyote_timer = coyote_frames 
	else:
		if coyote_timer > 0:
			coyote_timer -= 1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall_only()&&is_falling():
			velocity.y += gravity / 20 * delta
		else:
			velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		#phantom_cam.set_follow_target_offset(Vector2(phantom_cam.get_follow_target_offset().x*direction,phantom_cam.get_follow_target_offset().y))
		velocity.x += direction * SPEED * delta
	else:
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

	# Handle jump.
	if Input.is_action_just_pressed("jump") :
		if is_on_floor()||coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
		if is_on_wall_only():
			velocity.y = JUMP_VELOCITY
			if is_fully_on_left_wall():
				velocity.x = - JUMP_VELOCITY 
			elif is_fully_on_right_wall():
				velocity.x = JUMP_VELOCITY 

	if Input.is_action_just_released("jump")&&!is_falling()&&(velocity.y < -300 ):
		velocity.y += 160

	velocity.x = clamp(velocity.x,-MAX_SPEED,MAX_SPEED)
	move_and_slide()

func is_falling():
	return velocity.y > 0

func is_fully_on_right_wall():
	return right_wall_raycast_upper.is_colliding() && right_wall_raycast_lower.is_colliding()
func is_fully_on_left_wall():
	return left_wall_raycast_upper.is_colliding() && left_wall_raycast_upper.is_colliding()
	
func player_is_able_to_jump():
	return is_on_floor
