extends RigidBody2D
class_name Ball

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

#func _process(delta: float) -> void:
#	pass

func _on_Ball_body_entered(body: Node) -> void:
	$BumpAudio.play()
