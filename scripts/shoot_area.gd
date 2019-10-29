extends Area2D

func _ready():
	$auto_destruct.start()
	$Tween.interpolate_property(self, "scale", null, Vector2(3, 3), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_property($Light2D, "energy", null, 1, 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)

	$Tween.start()


func _on_shoot_area_body_entered(body):
	pass
		

func _on_auto_destruct_timeout():
	queue_free()
