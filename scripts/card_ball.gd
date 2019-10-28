extends Area2D

onready var self_color = $Sprite.modulate

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	pass
	
func _set_color(red, blue, green):
	self_color = Color(red, green, blue, 1)

func _on_card_ball_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.name == "card_ball":
		$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.2, 0.2), 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
		area.queue_free()


func _on_card_ball_mouse_exited():
	global_position = Vector2(600, 600)


func _on_Tween_tween_all_completed():
	queue_free()
