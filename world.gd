extends Node2D

var camera: Camera2D
var player: Player
var player_spawn_location = Vector2.ZERO
var respawn_timer: float = 0.0
var respawn_delay: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera2D
	player = $Player
	player_spawn_location = $Player.global_position
	player.connect_camera(camera)
	Events.connect("player_died", _on_player_died)

# This function will be called when the "player_died" signal is emitted
func _on_player_died():
	respawn_timer = respawn_delay

# Called every frame
func _process(delta: float):
	# Check if ESC key is pressed
	if Input.is_action_just_pressed("ui_end"):
		SoundPlayer.play_sound(SoundPlayer.PRESS)
		get_tree().change_scene_to_file("res://menu.tscn")
	
	if respawn_timer > 0:
		respawn_timer -= delta
		if respawn_timer <= 0:
			spawn_player()

func spawn_player():
	get_tree().reload_current_scene()
