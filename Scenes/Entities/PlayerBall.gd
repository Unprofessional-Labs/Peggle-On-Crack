extends Ball
class_name PlayerBall

var DASH_FORCE:int = 500
var ended:bool = false

var enable_dash_stalling:bool = false
var is_instance:bool = false

# modifier/powerup vars
var productBounceScale
var bounce_scales = {
	"bounce_powerup": 0.9, # base
	"absorbency_modifier": 1.0
}

var productGravityScale
var gravity_scales = {
	"base": 10,
	"ending": 1.0,
}

var sumDampingAddends
var damping_addends = {
	"base": 0,
	"ending": 0,
	"damping_modifier": 0
}

var productDashCooldown
var dash_cooldown_scales = {
	"base": 3,
	"uncontrollability_modifier": 1
}

var time_to_adjust_dash_multiplier = 1

func _ready() -> void:
	Global.get_node("DashTimer").connect("timeout", self, "_on_DashTimer_timeout")
	if is_instance:
		bounce_scales = Global.first_node_in_group("player").bounce_scales

func init(pos) -> void:
	global_position = pos
	is_instance = true

var charging_dash: bool = false

func start_dash():
	charging_dash = true
	Global.time_scales["player"] = 0.05
	
	var adjust_dash_time:float = 2*0.05*time_to_adjust_dash_multiplier
	
	$Tween.remove($TrajectoryLine, "line_extent")
	$Tween.interpolate_property($TrajectoryLine, "line_extent", $TrajectoryLine.line_extent, 1, adjust_dash_time/1.5, Tween.TRANS_SINE)
	$Tween.start()
	
	if !enable_dash_stalling:
		yield(get_tree().create_timer(adjust_dash_time), "timeout")
		
		if charging_dash:
			$Tween.remove($TrajectoryLine, "line_extent")
			$Tween.interpolate_property($TrajectoryLine, "line_extent", $TrajectoryLine.line_extent, 0, $DashHoldTimer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN)
			$Tween.start()
			
			$DashHoldTimer.start()

func get_speed() -> float:
	return linear_velocity.length()

func dash() -> void:
	$DashHoldTimer.stop()
	
	charging_dash = false
	$Tween.remove($TrajectoryLine, "line_extent")
	$Tween.interpolate_property($TrajectoryLine, "line_extent", $TrajectoryLine.line_extent, 0, 0.25, Tween.TRANS_SINE)
	$Tween.start()
	
	Global.time_scales.player = 1
	linear_velocity = Vector2.ZERO
	apply_central_impulse(global_position.direction_to(get_global_mouse_position()) * -DASH_FORCE)
	
	Global.get_node("DashTimer").start()
	Global.GAME_VAR.can_dash = false
	
	$DashTrailTimer.start()
	activate_trail()

func activate_trail():
	while !$DashTrailTimer.is_stopped():
		var instance = Global.PRELOADS.PlayerBallShadow.instance()
		instance.init(global_position)
		Global.add_world_node(instance)
		yield(get_tree().create_timer(0.05), "timeout")

func dash_update_process() -> void:
	Global.GAME_VAR.dash_cooldown_remaining_decimal = Global.get_node("DashTimer").time_left / Global.get_node("DashTimer").wait_time
	
	if Input.is_action_pressed("launch") && Global.get_node("DashTimer").is_stopped() && !charging_dash:
		start_dash()

	if Input.is_action_just_released("launch") && charging_dash:
		dash()
	
	if Global.get_node("DashTimer").is_stopped():
		$TrajectoryLine.rotation = -rotation + global_position.angle_to_point(get_global_mouse_position())

func end(enable:bool) -> void:
	if enable:
		if charging_dash:
			dash()
			
		gravity_scales["ending"] = 0
		damping_addends["ending"] = 1
		if abs(linear_velocity.x) < 5 && abs(linear_velocity.y) < 5:
			linear_velocity = Vector2.ZERO
			
			if !is_instance && Global.get_node("DeadPointsTimer").is_stopped():
				if !ended:
					Global.emit_signal("end_game")
					ended = true
			
	else:
		gravity_scales["ending"] = 1
		damping_addends["ending"] = 0
			

func anti_softlock() -> void:
	if abs(global_position.x) > 700:
		global_position.x = 0
	
	var peak_y = Global.get_world_node("Structures").peak_y
	if peak_y > global_position.y:
		global_position.y = peak_y + 100

func _physics_process(delta: float) -> void:
	$Sprite.global_rotation = 0
	$ComboParticles.emitting = Global.GAME_VAR.combo >= 25
	
	anti_softlock()
	
	productBounceScale = 1
	for j in bounce_scales:
		productBounceScale *= bounce_scales[j]
	bounce = productBounceScale
	
	productGravityScale = 1
	for j in gravity_scales:
		productGravityScale *= gravity_scales[j]
	gravity_scale = productGravityScale
	
	sumDampingAddends = 0
	for j in damping_addends:
		sumDampingAddends += damping_addends[j]
	linear_damp = sumDampingAddends
	
	productDashCooldown = 1
	for j in dash_cooldown_scales:
		productDashCooldown *= dash_cooldown_scales[j]
	Global.get_node("DashTimer").wait_time = productDashCooldown
	
	if Global.GAME_VAR.time_is_up:
		end(true)
		return
	else:
		end(false)
	
	dash_update_process()

#func _process(delta: float) -> void:
#	pass

func _on_DashTimer_timeout() -> void:
	Global.GAME_VAR.can_dash = true

func _on_DashHoldTimer_timeout() -> void:
	dash()
