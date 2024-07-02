extends StaticBody2D
class_name Peg

export var HP: int = 1
onready var INIT_HP = HP
export var POINTS: int = 1
export var BobbingCycleEnabled:bool = false

onready var Player: PlayerBall = get_tree().get_root().get_node("")

onready var initial_sprite_modulate = $Sprite.modulate

func initalize_peg() -> void:
	pass

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	initalize_peg()

func dmg(body) -> void:
	if HP <= 0:
		return
	
	# if body.
	
	$AnimationPlayer.play("Hit")
	var FINAL_POINTS = POINTS * Global.get_multiplier()
	HP -= 1
	
	if HP <= 0:
		Global.GAME_VAR.score += FINAL_POINTS
		addlabel()
		endtrigger(body)
		remove()
		
func remove() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
#	$ExplosionHitbox/CollisionShape2D.set_deferred("disabled", true)
	$Sprite.modulate = Color("41ffffff")
	$AnimationPlayer.play("Despawn")

func restore() -> void:
	$AnimationPlayer.play("Hit")
	$CollisionShape2D.set_deferred("disabled", false)
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
#	$ExplosionHitbox/CollisionShape2D.set_deferred("disabled", false)
	$Sprite.modulate = initial_sprite_modulate
	HP = INIT_HP

func addlabel() -> void:
	var FINAL_POINTS:int = POINTS * Global.get_multiplier()
	Global.add_score_label(global_position, str(FINAL_POINTS))

func trigger(body) -> void:
	pass
	
func endtrigger(body) -> void:
	pass

#func _process(delta: float) -> void:
#	pass

func _on_Hitbox_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	dmg(body)
	trigger(body)
	
	if body.get_node("PowerupHandler").is_piercing_powerup:
		$BumpAudio.play()
