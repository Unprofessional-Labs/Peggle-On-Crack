extends Node2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var children = get_children()
	
	for i in children:
		i.visible = false
	
	for i in range(min(Global.powerups.size(), children.size())):
		children[i].visible = true
		children[i].get_node("Sprite").frame = Global.powerups[i][2]
		children[i].get_node("TextureProgress").value = 1 - (Global.powerups[i][1]/10)
