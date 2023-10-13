extends RigidBody2D

@onready var controller = get_owner()

@onready var _wall_collide_sound = preload("res://audio/borderHit.wav")
@onready var _paddle_collide_sound = preload("res://audio/paddleHit.wav")
@onready var audio = %audio_stream;
@onready var camera = %Camera2D

@onready var glow_1 = %glow_1.get_material()
@onready var glow_2 = %glow_2.get_material()

var _current_glow = 1.;
@export var _min_glow = 1.1;
@export var _max_glow = 1.7;
@export var _glow_decay = .1;
@export var _glow_speed = 8.;
@export var _glow_gain = 1.;

@export var _max_angle = 1.5;
@export var _paddle_speed_to_get = 1.2;


var _movement = Vector2(10, 10);
@export var _do_speed_increase = false
@export var _speed_increase = .01



var _collision

enum {BORDER_HIT_SOUND, PADDLE_HIT_SOUND};

func reset():
	position = camera.get_screen_center_position()
	_movement = Vector2(randf_range(-10, 10), randf_range(-10, 10))

func add_angle_noise(vec):
	vec.x += randf_range(-.01, .01)
	vec.y += randf_range(-.01, .01)
	return vec

func _play_hit_sound(sound):
	match(sound):
		BORDER_HIT_SOUND:
			audio.stream = _wall_collide_sound
			pass
		PADDLE_HIT_SOUND:
			audio.stream = _paddle_collide_sound
			pass
	audio.play()
	
func _set_uniforms():
	glow_1.set_shader_parameter("u_speed", _glow_speed);
	glow_2.set_shader_parameter("u_speed", _glow_speed);
	glow_1.set_shader_parameter("u_hit", _current_glow);
	glow_2.set_shader_parameter("u_hit", _current_glow);
	
func check_player_collision():
	var _collider_name = _collision.get_collider().name
	return _collider_name == "Player" or _collider_name == "Player2"

func check_goal_collision():
	var _collider_name = _collision.get_collider().name
	if(_collider_name == "leftBorder"):
		return "PLAYER_2"
	elif(_collider_name == "rightBorder"):
		return "PLAYER_1"
	else:
		return false

func _calculate_bounce():
	_current_glow += _glow_gain;
	_movement = _movement.bounce(_collision.get_normal());
	_movement = add_angle_noise(_movement)
	if(check_player_collision()):
		_play_hit_sound(PADDLE_HIT_SOUND)
		var _collider_speed = Vector2(0, _collision.get_collider().currentSpeed)
		_movement += (_collider_speed * (_paddle_speed_to_get)) - (_collider_speed * .5)
	else:
		var goal = check_goal_collision()
		if(goal):
			controller.score(goal)
		else:
			_play_hit_sound(BORDER_HIT_SOUND)

func _calculate_new_movement(delta):
	if(_do_speed_increase) : _movement += Vector2(_speed_increase * sign(_movement.x), _speed_increase * sign(_movement.y))
	_movement.y = clamp(abs(_movement.y), 0, abs(_movement.x) * (_max_angle)) * sign(_movement.y)
	_movement.x = max(abs(_movement.x), 8.) * sign(_movement.x)

func _move():
	_collision = move_and_collide(_movement);

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	pass # Replace with function body.

func _physics_process(delta):
	if(!controller.freeze):
		_move();
		_calculate_new_movement(delta)
		if(_collision):
			_calculate_bounce()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_glow_speed = lerp(.001, 1., abs(_movement.length()))
	_current_glow = clamp(_current_glow - _glow_decay, _min_glow, _max_glow);
	_set_uniforms()
	pass
