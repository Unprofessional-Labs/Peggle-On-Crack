extends Node2D

func _ready() -> void:
	Global.connect("end_game", self, "end")



func end():
	$Text.bbcode_text = "GAME STATISTICS:\n\n"
	$Text.bbcode_text += "Total time: " + Global.bb_wrap_color(str(round(Global.STATS["total_time"])) + "s", "FFFF00") + "\n"
	$Text.bbcode_text += "Distance: " + Global.bb_wrap_color(str(round(Global.STATS["distance"])) + "m", "FFFF00") + "\n"
	$Text.bbcode_text += "Pegs destroyed: " + Global.bb_wrap_color(str(Global.STATS["pegs_destroyed"]) + " pegs", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak multiplier: " + Global.bb_wrap_color(str(Global.STATS["peak_multiplier"]) + "x multiplier", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak combo: " + Global.bb_wrap_color(str(Global.STATS["peak_combo"]) + " combo", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak ball count: " + Global.bb_wrap_color(str(Global.STATS["peak_ball_count"]) + " balls", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak destruction density: " + Global.bb_wrap_color(str(Global.STATS["peak_destruction_density_per_second"]) + " pegs destroyed per second", "FFFF00") + "\n"
