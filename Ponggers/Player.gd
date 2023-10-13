extends RigidBody2D
@onready var ball = %Ball
@onready var controller = get_owner()

var score = 0

var currentSpeed = 0;
var speed = 2;
var maxSpeed = 10;
var dampening = .8;

@export var _upKey = "arrow_up";
@export var _downKey = "arrow_down";

@export var CPU = false
@export var CPU_distance_to_action_modifier = 2.
@export var CPU_delay_chance = 10.

func _accelerate(val):
	currentSpeed = clamp(currentSpeed + val, -maxSpeed, maxSpeed);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _get_player_input():
	if(Input.is_action_pressed(_downKey)):
		_accelerate(speed)
	elif(Input.is_action_pressed(_upKey)):
		_accelerate(-speed)

func _get_CPU_input():
	if(abs(position.y - ball.position.y) > randf_range(scale.y * CPU_distance_to_action_modifier, (scale.y * 2) * CPU_distance_to_action_modifier) and randf_range(0., 100.) > CPU_delay_chance):
		_accelerate(sign(position.direction_to(ball.position).y) * speed)

func _physics_process(delta):
	if(!controller.freeze):
		move();
	
func move():
	
	if(!CPU):
		currentSpeed *= dampening;
		_get_player_input()
	else:
		_get_CPU_input()
	move_and_collide(Vector2(0, currentSpeed))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
