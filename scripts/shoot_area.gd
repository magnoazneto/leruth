extends Area2D

func _ready():
	$auto_destruct.start()


func _on_shoot_area_body_entered(body):
	pass
		

func _on_auto_destruct_timeout():
	queue_free()
