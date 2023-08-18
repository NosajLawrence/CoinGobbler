extends CharacterBody2D

const SPEED = 75.0
const JUMP_VELOCITY = -400.0
const IDLE_TIME = 1.0  # Time in seconds to idle before turning around

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animated_sprite: AnimatedSprite2D
var is_idling: bool = false
var idle_timer: float = 0.0
var direction = Vector2.RIGHT

# References to the LedgeCheck raycasts
var ledgeCheckLeft: RayCast2D
var ledgeCheckRight: RayCast2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	ledgeCheckLeft = $LedgeCheckLeft
	ledgeCheckRight = $LedgeCheckRight

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_idling:
		idle_timer += delta
		if idle_timer >= IDLE_TIME:
			is_idling = false
			idle_timer = 0.0
			direction *= -1  # Reverse direction
			move_enemy()

	if not is_idling:
		# Check for a ledge based on current direction. If found, set to idle.
		if (direction.x > 0 and not ledgeCheckRight.is_colliding()) or (direction.x < 0 and not ledgeCheckLeft.is_colliding()):
			is_idling = true  # Start idling
			idle_timer = 0.0  # Reset the idle timer
			velocity.x = 0  # Stop the enemy
			animated_sprite.play("Idle_r")

		else:
			move_enemy()

	move_and_slide()
	update_enemy_animation()

func move_enemy():
	velocity.x = direction.x * SPEED
	animated_sprite.flip_h = direction.x < 0

func update_enemy_animation():
	if is_on_floor():
		if velocity.x == 0 and not is_idling:
			animated_sprite.play("Idle_r")
			is_idling = true
		elif velocity.x != 0:
			if direction.x < 0:
				animated_sprite.play("Walking_r")
			else:
				animated_sprite.play("Walking_r")
				is_idling = false  # Reset idling status when moving
