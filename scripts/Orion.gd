extends KinematicBody2D

const WALK_SPEED = 200
const RUN_SPEED = 400

var movedir = Vector2(0,0)
var aim = Vector2()

func _physics_process(delta):
	controls_loop()
	movement_loop()
	animation_loop()
	

func controls_loop():
	var LEFT = Input.is_action_pressed("ui_a")
	var RIGHT = Input.is_action_pressed("ui_d")
	var UP = Input.is_action_pressed("ui_w")
	var DOWN = Input.is_action_pressed("ui_s")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)

func movement_loop():
	var RUN = Input.is_action_pressed("ui_run")
	var current_speed = 0
	if RUN:
		global_position = aim
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
	if movedir.y < 0:
		pass
