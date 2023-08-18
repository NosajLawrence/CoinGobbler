extends Control

func _on_play_pressed():
	SoundPlayer.play_sound(SoundPlayer.PRESS)
	get_tree().change_scene_to_file("res://world.tscn")

func _on_options_pressed():
	SoundPlayer.play_sound(SoundPlayer.PRESS)
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_quit_pressed():
	SoundPlayer.play_sound(SoundPlayer.DEATH)
	get_tree().quit()
