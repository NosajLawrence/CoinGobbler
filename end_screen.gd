extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if ESC key is pressed
	if Input.is_action_just_pressed("ui_end"):
		SoundPlayer.play_sound(SoundPlayer.VICTORY)
		get_tree().quit()
