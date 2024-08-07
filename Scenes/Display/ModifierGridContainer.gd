extends GridContainer

var panel_preload = preload("res://Scenes/Display/ModifierOptionPanel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Global.MODIFIER:
		var index = Global.MODIFIER[i]
		var instance = panel_preload.instance()
		instance.init(Global.modifier_max_level[index])
		add_child(instance)

#func _process(delta: float) -> void:
#	pass
