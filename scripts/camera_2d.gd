extends Camera2D

@onready var pos: Vector2 = position
var t: float = 0.0
var shake_factor: Vector2 = Vector2.ZERO
var shake_speed: float = 100

func _process(delta: float) -> void:
	t += delta
	position.y = pos.y + sin(t * shake_speed) * shake_factor.y
	position.x = pos.x + cos(t * shake_speed) * shake_factor.x
	
func shake(factor: Vector2, speed: float, time: float) -> void:
	shake_factor = factor
	shake_speed = speed
	await get_tree().create_timer(time).timeout
	shake_factor = Vector2.ZERO
	
