extends KinematicBody2D

const WALK_SPEED = 200
const RUN_SPEED = 400
const SHOOT = preload("res://scenes/shoot_area.tscn")
const AIM = preload("res://scenes/aim.tscn")
const CARD_BALL = preload("res://scenes/card_ball.tscn")

var movedir = Vector2(0,0)

onready var stage = get_parent()

func _ready():
	var blue_ball = CARD_BALL.instance()
	var red_ball = CARD_BALL.instance()
	$HUD.add_child(blue_ball)
	$HUD.add_child(red_ball)
	blue_ball.global_position = Vector2(100, 20)
	red_ball.global_position = Vector2(20, 20)

func _physics_process(delta):
	controls_loop()
	movement_loop()
	animation_loop()
		

func controls_loop():
	var LEFT = Input.is_action_pressed("ui_a")
	var RIGHT = Input.is_action_pressed("ui_d")
	var UP = Input.is_action_pressed("ui_w")
	var DOWN = Input.is_action_pressed("ui_s")
	if Input.is_action_just_pressed("ui_shoot"):
		_shoot()
	if Input.is_action_just_pressed("ui_pick"):
		_fusion()
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)


func _fusion():
	"""
	var aim = AIM.instance()
	$HUD.add_child(aim)
	aim.global_position = get_global_mouse_position()
	"""
	pass
	
func _shoot():
	var shoot_ball = SHOOT.instance()
	stage.add_child(shoot_ball)
	shoot_ball.global_position = get_global_mouse_position()
	
	
func movement_loop():
	var RUN = Input.is_action_pressed("ui_run")
	var current_speed = 0
	if RUN:
		current_speed = RUN_SPEED
		$walkSprite/walkAnim.playback_speed = 4
	else:
		current_speed = WALK_SPEED
		$walkSprite/walkAnim.playback_speed = 2

	var motion = movedir.normalized() * current_speed
	move_and_slide(motion, Vector2(0,0))


func animation_loop():
	if movedir.x > 0:
		$walkSprite.flip_h = true
		$walkSprite/walkAnim.play("walk")
	elif movedir.x < 0:
		$walkSprite.flip_h = false
		$walkSprite/walkAnim.play("walk")
	else:
		$walkSprite/walkAnim.stop()
		$walkSprite.frame = 0
