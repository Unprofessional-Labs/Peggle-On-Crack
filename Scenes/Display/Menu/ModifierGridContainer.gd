extends GridContainer

var panel_preload = preload("res://Scenes/Display/Menu/ModifierOptionPanel.tscn")

signal modifier_mouse_enter(index)
signal modifier_mouse_exit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("switch_to_menu", self, "reload")
	reload()

func reload() -> void:
	for i in Global.MODIFIER:
		var index = Global.MODIFIER[i]
		if Global.modifier_max_level[index] > 0:
			var instance = panel_preload.instance()
			instance.init(index)
			add_child(instance)

#func _process(delta: float) -> void:
#	pass
