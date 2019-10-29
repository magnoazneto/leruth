extends Node2D

const MONSTER = preload("res://scenes/enemy.tscn")
const MAGIC_BALL = preload("res://scenes/aim.tscn")
onready var area = $nav2D/ground.get_used_cells()
onready var nav2d : Navigation2D = $nav2D
onready var wave_enemys = 0
onready var living_enemys = 0
onready var summon_enabled = true
onready var magic_balls = 0
onready var summon_magic = true

func _ready():
	pass

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

func _on_spawnMonster_timeout():
	summon_enabled = true


func _on_spawmMagic_timeout():
	summon_magic = true
