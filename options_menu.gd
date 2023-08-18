extends Control

signal skin_selected(skin_color)

func _on_green_pressed():
	SoundPlayer.play_sound(SoundPlayer.PRESS)
	GlobalData.set_skin("green")
	get_tree().change_scene_to_file("res://world.tscn")

func _on_blue_pressed():
	SoundPlayer.play_sound(SoundPlayer.PRESS)
	GlobalData.set_skin("blue")
	get_tree().change_scene_to_file("res://world.tscn")


func _on_back_pressed():
	SoundPlayer.play_sound(SoundPlayer.PRESS)
	get_tree().change_scene_to_file("res://menu.tscn")
