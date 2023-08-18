extends CharacterBody2D
class_name Player

# Constants for movement
const SPEED = 200.0
const ACCELERATION = 1000.0
const FRICTION = 250.0
const JUMP_VELOCITY = -350
const FAST_FALL_MULTIPLIER = 3.0
const MIN_JUMP_TIME = 0.2
const MAX_JUMP_TIME = 0.5
const COYOTE_TIME = 0.1  # The buffer time for coyote jump
var current_jump_time = 0.0
var is_on_floor_buffer = false  # A buffer flag to handle coyote jump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variables for smooth movement
var target_velocity = Vector2.ZERO
var last_movement_direction = 1  # 1: Right, -1: Left

# Reference to the AnimatedSprite2D node
var animated_sprite: AnimatedSprite2D

# Variable to store the player's skin color
var player_skin_color: String

var ladderCheck: RayCast2D

var remoteTransform2D: RemoteTransform2D

var score_node: Node2D

signal player_died
signal skin_selected(skin_color)

# Add a variable to store the player's score.
var score: int = 0

func _ready():
	animated_sprite = $AnimatedSprite2D
	ladderCheck = $LadderCheck
	remoteTransform2D = $RemoteTransform2D
	player_skin_color = GlobalData.get_skin()
	score_node = $Score


func _on_skin_selected(skin_color: String):
	player_skin_color = skin_color
	update_player_animation()  # Update animation to reflect the new skin

# Function to add score.
func add_score(points: int) -> void:
	SoundPlayer.play_sound(SoundPlayer.COIN)
	score += points
	score = clamp(score, 0, 99) # Ensure the score is between 0 to 99
	print(score)
	score_node.update_score_display(score)  # Update the score display

func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func player_die():
	SoundPlayer.play_sound(SoundPlayer.DEATH)
	Events.emit_signal("player_died")
	queue_free()

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func _physics_process(delta):
	# Check if the player has fallen below the specified Y-coordinate
	if global_position.y > 1400:
		player_die()
	
	if is_on_ladder():
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED  # You can adjust the speed value to control climbing speed
		else:
			velocity.y = 0  # Stops the player from sliding down if no input is given on the ladder

	# Add the gravity.
	if not is_on_floor():
		# Check if the player is holding the down arrow key for fast fall.
		if Input.is_action_pressed("ui_down"):
			velocity.y += gravity * delta * FAST_FALL_MULTIPLIER
		else:
			velocity.y += gravity * delta

	# Handle Coyote Jump
	if is_on_floor():
		is_on_floor_buffer = true
	else:
		if is_on_floor_buffer and current_jump_time < COYOTE_TIME:
			# If the player is in the coyote time and presses jump, execute a coyote jump.
			if Input.is_action_just_pressed("ui_accept"):
				SoundPlayer.play_sound(SoundPlayer.JUMP)
				velocity.y = JUMP_VELOCITY
				current_jump_time = MAX_JUMP_TIME

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		current_jump_time = 0.0

	if Input.is_action_pressed("ui_accept") and is_on_floor() and current_jump_time < MAX_JUMP_TIME:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = JUMP_VELOCITY
		current_jump_time += delta

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.25  # Reduce upward velocity to allow selectable jump height

	# Get the input direction and calculate the target velocity.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	target_velocity.x = direction * SPEED

	# Update the last movement direction to determine facing direction during idle and jumping.
	if target_velocity.x != 0:
		last_movement_direction = sign(target_velocity.x)

	# Apply acceleration and friction to achieve smooth movement.
	# Accelerate towards the target velocity in the x-direction.
	velocity.x = move_toward(velocity.x, target_velocity.x, ACCELERATION * delta)
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# Update the player's animation based on movement direction and state
	update_player_animation()

	move_and_slide()


func update_player_animation():
	# Determine the direction prefix based on the last movement direction
	var direction_prefix = "l_" if last_movement_direction < 0 else "r_"
	var animation_type = ""

	if is_on_floor():
		if target_velocity.x == 0:
			animation_type = "idle"
		else:
			animation_type = "moving"
	else:
		animation_type = "jumping"

	# Add the skin color to the animation name
	var full_animation_name = direction_prefix + animation_type + "_" + player_skin_color
	animated_sprite.play(full_animation_name)
