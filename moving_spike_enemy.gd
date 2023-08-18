extends Path2D

enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}

var animation_type: ANIMATION_TYPE = ANIMATION_TYPE.BOUNCE # Default animation type

func set_animation_type(value):
	animation_type = value
	play_updated_animation(animationPlayer)

# Called when the node enters the scene tree for the first time.
func _ready():
	play_updated_animation(animationPlayer)



