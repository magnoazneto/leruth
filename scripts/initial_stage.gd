extends Node2D

const MONSTER = preload("res://scenes/enemy.tscn")
const MAGIC_BALL = preload("res://scenes/aim.tscn")
onready var area = $nav2D/ground.get_used_cells()
onready var spawn_area = $nav2D/ground.get_used_cells()
onready var walls = $nav2D/TileMap
onready var nav2d : Navigation2D = $nav2D
onready var wave_enemys = 0
onready var living_enemys = 0
onready var summon_enabled = true
onready var magic_balls = 0
onready var summon_magic = true

func _ready():
	generate_stage()
	print(len($nav2D/TileMap.get_used_cells()))
	$day_tween.interpolate_property($dayligth, "color", Color(1,1,1,1), Color(0.05, 0.05, 0.2, 1), 7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$day_tween.start()


func _physics_process(delta):		
	if wave_enemys == 20 and living_enemys == 0:
		get_tree().reload_current_scene()
	if wave_enemys < 20 and summon_enabled:
		summon()
	if magic_balls < 5 and summon_magic:
		summon_magic_ball()


func summon_magic_ball():
	var next_ball = MAGIC_BALL.instance()
	add_child(next_ball)
	magic_balls += 1
	randomize()
	area.shuffle()
	var point = $nav2D/ground.map_to_world(area[1])
	next_ball.global_position = point
	summon_magic = false
	$spawmMagic.start()


func summon():
	var monster = MONSTER.instance()
	add_child(monster)
	wave_enemys += 1
	living_enemys += 1
	randomize()
	area.shuffle()
	var point = $nav2D/ground.map_to_world(area[0])
	monster.global_position = point
	summon_enabled = false
	$spawnMonster.start()


func generate_stage():
	var direction_control = false 
	for i in range(80):
		randomize()
		spawn_area.shuffle()
		var tile_point = spawn_area[0]
		direction_control = not direction_control
		#spawn_area.remove(0)
		make_wall(tile_point, direction_control)
			

	walls.update_dirty_quadrants()
	

func is_wall_possible(seed_position, vertical):
	var cell = Vector2()
	if vertical:
		for i in range(8):
			for j in range(2):
				if walls.get_cell(seed_position.x+j, seed_position.y+i) != -1:
					return false
		return true
	else:
		for i in range(8):
			for j in range(2):
				if walls.get_cell(seed_position.x+i, seed_position.y+j) != -1:
					return false
		return true


func make_wall(seed_position, vertical=true, counter=1):
	if vertical:
		for i in range(4):
			for j in range(2):
				walls.set_cell(seed_position.x+j, seed_position.y+i, 0)
				walls.update_bitmask_area(Vector2(seed_position.x+j, seed_position.y+i))
		
		seed_position.y += 4
		if counter <= 2:
			if is_wall_possible(seed_position, true):
				make_wall(seed_position, not vertical, counter+1)
	else:
		for i in range(4):
			for j in range(2):
				walls.set_cell(seed_position.x+i, seed_position.y+j, 0)
				walls.update_bitmask_area(Vector2(seed_position.x+i, seed_position.y+j))
		
		seed_position.x += 4
		if counter <= 2:
			if is_wall_possible(seed_position, false):
				make_wall(seed_position, not vertical, counter+1)
				

func _on_spawnMonster_timeout():
	summon_enabled = true


func _on_spawmMagic_timeout():
	summon_magic = true
