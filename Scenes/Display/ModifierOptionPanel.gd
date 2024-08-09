extends Panel

var count = 0
var max_count = 0
var index = 0

func init(index_param):
	index = index_param
	max_count = Global.modifier_max_level[index]
	count = Global.modifier_levels[index]

func _ready() -> void:
	update()

func _on_Button_pressed() -> void:
	count += 1
	if count > max_count:
		count = 0
	update()

func update():
	Global.modifier_levels[index] = count
	
	$Button.text = str(count)
