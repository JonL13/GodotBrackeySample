extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 130
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = .3
const MAX_JUMPS = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0
var num_jump_available = MAX_JUMPS

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	handle_jump(delta)

	# Gets the input direction, -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	animate_sprite(direction)
	apply_movement(direction)
	

func handle_jump(delta) -> void:
	if !is_on_floor():
		coyote_timer += delta
	else:
		coyote_timer = 0
		num_jump_available = MAX_JUMPS
		
	if coyote_timer > COYOTE_TIME and num_jump_available == MAX_JUMPS:
		num_jump_available -=1

	if Input.is_action_just_pressed("jump") and num_jump_available > 0:
		velocity.y = JUMP_VELOCITY
		num_jump_available -= 1	
	

func animate_sprite(direction):
	#Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	#play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

func apply_movement(direction) -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
