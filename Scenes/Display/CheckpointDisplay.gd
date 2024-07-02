extends Node2D

func _ready() -> void:
	modulate.a = 0
	Global.connect("announce_checkpoint", self, "announce")

func announce() -> void:
	$Sprite.frame = Global.get_world_node("Structures").CURRENT_CHECKPOINT - 1
	var duration = 1
	var idle_duration = 2
	$Tween.interpolate_property(self, "modulate:a", 0, 1, duration, Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(duration + idle_duration), "timeout")
	$Tween.interpolate_property(self, "modulate:a", 1, 0, duration, Tween.TRANS_LINEAR)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
