extends Node2D

# References to the AnimatedSprite2D nodes for first and second decimals
var first_decimal_sprite = AnimatedSprite2D
var second_decimal_sprite = AnimatedSprite2D

func _ready():
	first_decimal_sprite = $FirstDecimalSprite
	second_decimal_sprite = $SecondDecimalSprite
	pass # Replace with function body.

# Update the score display based on the player's score.
func update_score_display(score: int):
	# Ensure the score stays within 0 to 99.
	score = clamp(score, 0, 99)
	
	# Calculate the first and second decimal digits.
	var first_decimal = score / 10
	var second_decimal = score % 10

	# Update the AnimatedSprite2D frames.
	first_decimal_sprite.play(str(first_decimal))
	second_decimal_sprite.play(str(second_decimal))
