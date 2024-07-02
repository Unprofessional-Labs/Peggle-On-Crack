extends "res://Scenes/Entities/Pegs/BombPeg.gd"

func detonate_effect(pegBody) -> void:
	pegBody.restore()
