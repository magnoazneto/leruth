extends KinematicBody2D

const SPEED = 200
const RAGE_MODIFIER = 0.06
onready var player = get_parent().get_node("Orion")
onready var stage = get_parent()
onready var line = stage.get_node("Line2D")
onready var map = stage.get_node("nav2D/TileMap")
var direction_x = 1
var direction_y = 1
var motion = Vector2()
var path : = PoolVector2Array()
var seeking = false
onready var rage = 0
onready var R_sonar = $sonar_right
onready var L_sonar = $sonar_left
onready var U_sonar = $sonar_up
onready var D_sonar = $sonar_down
onready var break_wall = false
onready var tile_target = Vector2()


func _ready():
	set_process(true)
	

func _physics_process(delta):
	{
		
#	if Input.is_action_just_pressed("ui_shoot"):
#		seeking = true
#	elif Input.is_action_just_released("ui_shoot"):
#		$seekTime.start()
#	if seeking:
#		path = stage.nav2d.get_simple_path(global_position, player.global_position)
#		var move_distante = SPEED * delta
#		move_along_path(move_distante)
		#$Tween.interpolate_property(self, "position", path[0], path[len(path)-1], 0.1*len(path), Tween.TRANS_SINE, Tween.EASE_OUT)
		#seeking = false
		#$Tween.start()
	#elif position.distance_to(player.position) < 100:
		}
	_set_dir()
	_seek_player()
	if position.distance_to(player.position) <= 50:
		player.life -= 1


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
	#print("Rage: ", rage)
	motion.x = direction_x * SPEED
	motion.y = direction_y * SPEED
	if R_sonar.is_colliding():
		rage += RAGE_MODIFIER
		if rage >= 5:
			tile_target = map.world_to_map(global_position)
			tile_target.x += 1
			explode_cells("right")
	if U_sonar.is_colliding():
		rage += RAGE_MODIFIER
		if rage >= 5:
			tile_target = map.world_to_map(global_position)
			tile_target.y -= 1
			explode_cells("up")
	if D_sonar.is_colliding():
		rage += RAGE_MODIFIER
		if rage >= 5:
			tile_target = map.world_to_map(global_position)
			tile_target.y += 1
			explode_cells("down")
	if L_sonar.is_colliding():
		rage += RAGE_MODIFIER
		if rage >= 5:
			tile_target = map.world_to_map(global_position)
			tile_target.x -= 1
			explode_cells("left")
	
	move_and_slide(motion, Vector2(0, 0))
		

func explode_cells(wall_dir):
	if wall_dir == "right":
		map.set_cell(tile_target.x, tile_target.y, -1)
		map.set_cell(tile_target.x, tile_target.y+1, -1)
		map.set_cell(tile_target.x, tile_target.y-1, -1)
		map.set_cell(tile_target.x+1, tile_target.y, -1)
		map.set_cell(tile_target.x+1, tile_target.y+1, -1)
		map.set_cell(tile_target.x+1, tile_target.y-1, -1)
	elif wall_dir == "up":
		map.set_cell(tile_target.x, tile_target.y, -1)
		map.set_cell(tile_target.x, tile_target.y-1, -1)
		map.set_cell(tile_target.x+1, tile_target.y, -1)
		map.set_cell(tile_target.x+1, tile_target.y-1, -1)
		map.set_cell(tile_target.x-1, tile_target.y, -1)
		map.set_cell(tile_target.x-1, tile_target.y-1, -1)
	elif wall_dir == "down":
		map.set_cell(tile_target.x, tile_target.y, -1)
		map.set_cell(tile_target.x, tile_target.y+1, -1)
		map.set_cell(tile_target.x+1, tile_target.y, -1)
		map.set_cell(tile_target.x+1, tile_target.y+1, -1)
		map.set_cell(tile_target.x-1, tile_target.y, -1)
		map.set_cell(tile_target.x-1, tile_target.y+1, -1)
	elif wall_dir == "left":
		map.set_cell(tile_target.x, tile_target.y, -1)
		map.set_cell(tile_target.x, tile_target.y+1, -1)
		map.set_cell(tile_target.x, tile_target.y-1, -1)
		map.set_cell(tile_target.x-1, tile_target.y, -1)
		map.set_cell(tile_target.x-1, tile_target.y+1, -1)
		map.set_cell(tile_target.x-1, tile_target.y-1, -1)
	rage = 0
	
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
		stage.living_enemys -= 1
		queue_free()

func _on_seekTime_timeout():
	seeking = false

func _on_Tween_tween_completed(object, key):
	seeking = true
