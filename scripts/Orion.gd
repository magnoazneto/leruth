extends KinematicBody2D

const WALK_SPEED = 200
const RUN_SPEED = 400
const SHOOT = preload("res://scenes/shoot_area.tscn")
const AIM = preload("res://scenes/aim.tscn")

var movedir = Vector2(0,0)
var magic = 10
var charging = false
var life = 1000

onready var stage = get_parent()


func _ready():
	pass


func _physics_process(delta):
	if life <= 0:
		get_tree().reload_current_scene()
	controls_loop()
	movement_loop()
	animation_loop()
	refresh_hud()
	if magic < 10 and not charging:
		$chargeTimer.start()
		charging = true


func controls_loop():
	var LEFT = Input.is_action_pressed("ui_a")
	var RIGHT = Input.is_action_pressed("ui_d")
	var UP = Input.is_action_pressed("ui_w")
	var DOWN = Input.is_action_pressed("ui_s")
	if Input.is_action_just_pressed("ui_shoot") and magic > 0:
		_shoot()
	if Input.is_action_just_pressed("ui_pick"):
		_fusion()
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)


func refresh_hud():
	$HUD/wave_counter.set_bbcode("Summoned: " + str(stage.wave_enemys) + " Alive: " + str(stage.living_enemys))
	$HUD/magic_counter.set_bbcode("Magic: " + str(magic))
	$HUD/life_counter.set_bbcode("Life: " + str(life))
	
	
func _fusion():
	"""
	var aim = AIM.instance()
	$HUD.add_child(aim)
	aim.global_position = get_global_mouse_position()
	"""
	pass


func _shoot():
	magic -= 1
	var shoot_ball = SHOOT.instance()
	var target = get_global_mouse_position()
	stage.add_child(shoot_ball)
	$Tween.interpolate_property(shoot_ball, "global_position", global_position, target, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
	
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


func _on_chargeTimer_timeout():
	magic += 1
	charging = false
	
