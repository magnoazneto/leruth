extends Area2D

onready var player = get_parent().get_node("Orion")
onready var stage = get_parent()

func _ready():
	pass

func _on_destruction_timer_timeout():
	queue_free()


func _on_aim_body_entered(body):
	if body.name == "Orion":
		player.magic += 1
		stage.magic_balls -= 1
		if player.life <= 1000:
			player.life += 50
		queue_free()
