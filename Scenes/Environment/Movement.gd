extends Path2D

export var reverse = false
onready var current_reverse = reverse
export var offsetSeconds:float = 0
onready var length = curve.get_baked_length()

func _ready():
	reset()
	Global.connect("reset", self, "reset")
	
func reset():
	$Interval.stop()
	$PathFollow2D.offset = 0
	$Tween.remove_all()
	current_reverse = reverse
	
	yield(get_tree().create_timer(offsetSeconds), "timeout")
	$Interval.start()

func _process(delta):
	pass

func _on_Interval_timeout() -> void:
	if !current_reverse:
		$Tween.interpolate_property($PathFollow2D, "offset", 0, length, $Interval.wait_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	else:
		$Tween.interpolate_property($PathFollow2D, "offset", length, 0, $Interval.wait_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	current_reverse = !current_reverse
