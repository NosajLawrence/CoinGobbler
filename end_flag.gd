extends Node2D
class_name End_Flag

var animation_player: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $AnimatedSprite2D
	animation_player.play("default")

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		SoundPlayer.play_sound(SoundPlayer.VICTORY)
		print("Player entered the end flag area.")
		get_tree().change_scene_to_file("res://end_screen.tscn")
