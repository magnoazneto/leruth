extends Particles2D

onready var player = get_parent().get_node("Orion")
onready var following = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	_movement_loop()

func _movement_loop():
	if global_position.distance_to(player.global_position) <= 100:
		pass 
		#movimentação de guarda
	else:
		if not following:
			following = true
			$follow_timer.start()


func _on_follow_timer_timeout():
	$follow_tween.interpolate_property(self, "global_position", null, player.global_position, 1, Tween.TRANS_SINE, Tween.EASE_OUT)
	$follow_tween.start()


func _on_follow_tween_tween_completed(object, key):
	following = false
