extends Node2D

var p1_score: int = 0
var p2_score: int = 0

func _process(_delta: float) -> void:
	%P1Score.text = str(p1_score)
	%P2Score.text = str(p2_score)
