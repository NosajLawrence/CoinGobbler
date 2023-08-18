extends Node

const DEATH = preload("res://Sounds/death.wav")
const COIN = preload("res://Sounds/coin.wav")
const JUMP = preload("res://Sounds/jump.wav")
const VICTORY = preload("res://Sounds/victory.wav")
const PRESS = preload("res://Sounds/Press.wav")

var audioPlayers

# Called when the node enters the scene tree for the first time.
func _ready():
	audioPlayers = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
