extends KinematicBody2D

const WALK_SPEED = 200
const RUN_SPEED = 400

var movedir = Vector2(0,0)

func _physics_process(delta):
	controls_loop()
	movement_loop()

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
	current_speed = RUN_SPEED if RUN else WALK_SPEED
	var motion = movedir.normalized() * current_speed
	move_and_slide(motion, Vector2(0,0))
