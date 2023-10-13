extends Node2D
@onready var player_1 = $Player
@onready var player_2 = $Player2
@onready var ball = $Ball
@onready var camera = $Camera2D
@onready var scoreboard = $Scoreboard
@onready var audio = $audio_stream
@onready var p1_score_audio = preload("res://audio/p1Score.wav")
@onready var p2_score_audio = preload("res://audio/p2Score.wav")

@onready var camera_center = camera.get_screen_center_position()
@onready var camera_right_border = camera.get_viewport_rect().end.x
@onready var camera_left_border = camera.get_viewport_rect().position.x

@export var freeze = false;
@export var score_separator = " - "

@export var scores = {
	"PLAYER_1" : 0,
	"PLAYER_2" : 0
}

signal key_press

func _input(event):
	if event.is_pressed():
		key_press.emit()

func update_score():
	scoreboard.text = str(scores.PLAYER_1) + score_separator + str(scores.PLAYER_2)
	
func add_score(player, score_val):
	scores[player] += score_val
	update_score()

func set_score(player, score_val):
	scores[player] = score_val
	update_score()
	
func score(player):
	freeze = true;
	audio.stream = p1_score_audio if (player == "PLAYER_1") else p2_score_audio
	audio.play()
	await get_tree().create_timer(.5).timeout
	add_score(player, 1)
	restart()
	await key_press
	freeze = false;
	

func start():
	freeze = true
	restart()
	set_score("PLAYER_1", 0)
	set_score("PLAYER_2", 0)
	await key_press
	freeze = false
	
func restart():
	ball.reset()
	player_1.position = Vector2(camera_left_border + 80, camera_center.y);
	player_2.position = Vector2(camera_right_border - 80, camera_center.y);
	

func _ready():
	start()

func _process(delta):
	if(Input.is_action_pressed("reset")):
		start()
	if(Input.is_action_pressed("esc")):
		get_tree().change_scene_to_file("res://menu.tscn")
