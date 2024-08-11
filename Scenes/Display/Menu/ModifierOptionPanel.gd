extends Panel

var count = 0
var max_count = 0
var index = 0

func init(index_param):
	index = index_param
	max_count = Global.modifier_max_level[index]
	count = Global.modifier_levels[index]

func _ready() -> void:
	$Sprite.frame = index
	update()

func _on_Button_pressed() -> void:
	count += 1
	if count > max_count:
		count = 0
	update()

func update():
	Global.modifier_levels[index] = count
	Global.update_modifier_values()
	
	$Text.bbcode_text = "" if count == 0 else "[color=#FFFF00]"
	$Text.bbcode_text += "[center]" + str(count)
	
	get_parent().emit_signal("modifier_mouse_enter", index)

func _on_Button_mouse_entered() -> void:
	get_parent().emit_signal("modifier_mouse_enter", index)

func _on_Button_mouse_exited() -> void:
	get_parent().emit_signal("modifier_mouse_exit")

func _on_ModifierOptionPanel_mouse_entered() -> void:
	pass

func _on_ModifierOptionPanel_mouse_exited() -> void:
	pass
