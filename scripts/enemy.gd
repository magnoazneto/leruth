extends KinematicBody2D

const SPEED = 100
onready var player = get_parent().get_node("Orion")
onready var stage = get_parent()
onready var line = stage.get_node("Line2D")
var direction_x = 1
var direction_y = 1
var motion = Vector2()
var path : = PoolVector2Array()

func _ready():
	set_process(true)

func _physics_process(delta):
	path = stage.nav2d.get_simple_path(global_position, player.global_position)
	line.points = path
	var move_distante = SPEED * delta
	if position.distance_to(player.position) >= 50:
		move_along_path(move_distante)
	#_set_dir()
	#_seek_player()


func move_along_path(distance: float):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0:
			position = path[0]
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)


func _seek_player():
	motion.x = direction_x * SPEED
	motion.y = direction_y * SPEED
	move_and_slide(motion, Vector2(0, 0))
	


func _set_dir():
	if player.position.x < position.x:
		direction_x = -1
	elif player.position.x > position.x:
		direction_x = 1
	else:
		direction_x = 0
			
	if player.position.y < position.y:
		direction_y = -1
	elif player.position.y > position.y:
		direction_y = 1
	else:
		direction_y = 0

func _on_hitbox_area_entered(area):
	if area.name == "shoot_area":
		stage.wave_enemys -= 1
		area.queue_free()
		queue_free()
