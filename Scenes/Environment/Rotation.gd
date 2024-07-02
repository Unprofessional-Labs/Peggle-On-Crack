extends Node2D

export var roundsPerSecond = 0.5 # negative for reverse
export var rotationLock = true

func _ready():
	reset()
	Global.connect("reset", self, "reset")
	
func reset():
	rotation_degrees = 0

func _process(delta):
	var change = roundsPerSecond*360*delta
	
	rotation_degrees += change
	if rotationLock:
		for i in get_children():
			i.rotation_degrees -= change
