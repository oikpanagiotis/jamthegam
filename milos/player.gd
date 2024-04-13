class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var coyote_timer_frames = 5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0

var input = Vector2.ZERO
func _process(delta):
	if is_on_floor():
		coyote_timer = coyote_timer_frames * delta
	else:
		if coyote_timer > 0:
			coyote_timer -= delta

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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor()||coyote_timer > 0):
		velocity.y = JUMP_VELOCITY
	move_and_slide()

func is_falling():

	return velocity.y > 0

func player_is_able_to_jump():
	return is_on_floor
