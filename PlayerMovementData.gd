extends Resource
class_name PlayerMovementData

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
