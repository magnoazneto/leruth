extends Area2D

func _ready():
	pass

func _on_destruction_timer_timeout():
	queue_free()
