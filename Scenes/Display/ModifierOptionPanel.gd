extends Panel

var count = 0
var max_count = 0

func init(max_count_param):
	max_count = max_count_param

func _ready() -> void:
	update()

func _on_Button_pressed() -> void:
	count += 1
	if count > max_count:
		count = 0
	update()

func update():
	$Button.text = str(count)
