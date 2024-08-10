extends Node

onready var ball:PlayerBall = get_parent()

var is_piercing_powerup = false
var multiballLists = [] # 2d array of balls
var ghost_positions = []

var UNSTACKABLE_POWERUPS = [Global.POWERUP.super_bounce, Global.POWERUP.bamboozle, Global.POWERUP.pierce, Global.POWERUP.enlarge]

func toggle_powerup(powerup: int, enable: bool) -> void:
	if !enable:
		if UNSTACKABLE_POWERUPS.has(powerup):
			var powerupExists = false
			for i in Global.powerups:
				if powerup == i[0]:
					powerupExists = true
					break
			if powerupExists:
				return
	
	match powerup:
		Global.POWERUP.super_bounce:
			if enable:
				ball.bounce_scales["bounce_powerup"] = 1
			else:
				ball.bounce_scales["bounce_powerup"] = 0.9
		
		Global.POWERUP.slow_time:
			if !ball.is_instance:
				if enable:
					Global.time_ticking_scales["slow_time_powerup"] *= 0.25
				else:
					Global.time_ticking_scales["slow_time_powerup"] /= 0.25
			
		Global.POWERUP.bamboozle:
			pass
		
		Global.POWERUP.pierce:
			is_piercing_powerup = enable
			ball.set_collision_mask_bit(5, !enable)
			ball.get_node("TrajectoryLine/Raycast").set_collision_mask_bit(5, !enable)
		
		Global.POWERUP.multiball:
			if !ball.is_instance:
				if enable:
					var number_of_extra_balls = 2
					multiballLists.append([])
					
					for i in range(number_of_extra_balls):
						var instance = Global.PRELOADS.PlayerBall.instance()
						instance.init(ball.global_position)
						get_tree().get_root().add_child(instance)
						multiballLists[multiballLists.size()-1].append(instance)
				else:
					for i in multiballLists[0]:
						i.queue_free()
					multiballLists.remove(0)
		
		Global.POWERUP.enlarge:
			var scale_multiplier:Vector2 = ball.get_node("CollisionShape2D").scale
			if enable:
				scale_multiplier *= Vector2(1.5, 1.5)
			else:
				scale_multiplier = Vector2(1, 1)
				# scale_multiplier = Vector2(max(1, scale_multiplier.x), max(1, scale_multiplier.y))
			
			ball.get_node("CollisionShape2D").scale = scale_multiplier
			ball.get_node("Hitbox").scale = scale_multiplier
			ball.get_node("Sprite").scale = scale_multiplier
			
			is_piercing_powerup = enable
			ball.set_collision_mask_bit(5, !enable)
			ball.get_node("TrajectoryLine/Raycast").set_collision_mask_bit(5, !enable)

		Global.POWERUP.ghost:
			if enable:
				ghost_positions.append(ball.global_position)
				ball.modulate = Color("1", "1", "1", "0.5")
			else:
				ball.global_position = ghost_positions[0]
				ghost_positions.remove(0)
				
				if ghost_positions.size() == 0:
					ball.modulate = Color("1", "1", "1", "1")

func _ready() -> void:
#	yield(get_tree(), "idle_frame")
	Global.connect("triggerPowerup", self, "toggle_powerup")

func _process(delta: float) -> void:
	pass

func _on_PowerupDuration_timeout() -> void:
	pass
