extends Node2D
class_name Coin

var animation_player: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $AnimatedSprite2D
	animation_player.play("coin_spin")

# Called when another physics body enters the collision shape.
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.add_score(1)  # Call a function in the Player script to add score.
		queue_free()  # Destroy the coin when the player touches it.
