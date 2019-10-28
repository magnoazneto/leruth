extends Node2D

const MONSTER = preload("res://scenes/enemy.tscn")
onready var nav2d : Navigation2D = $nav2D
onready var wave_enemys = 0
onready var summon_enabled = true

func _ready():
	pass

func _physics_process(delta):
	if wave_enemys < 5 and summon_enabled:
		summon()


func summon():
	var monster = MONSTER.instance()
	add_child(monster)
	wave_enemys += 1
	monster.global_position = Vector2(-20, 140)
	summon_enabled = false
	$spawnMonster.start()

func _on_spawnMonster_timeout():
	summon_enabled = true
