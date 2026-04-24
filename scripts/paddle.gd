extends Area2D

@export var is_ai: bool = false
@export var ball: Node2D
@export var player: String = "p1"
@export var min_y: float = 25.0
@export var max_y: float = 623.0

@onready var start_pos: Vector2 = position

var height: float

@export var SPEED: float = 300

func _ready() -> void:
	height = $CollisionShape2D.shape.size.y

func _physics_process(delta: float) -> void:
	if ball.in_play:
		if is_ai:
			_ai_movement(delta)
		else:
			_player_movement(delta)
	else:
		_reset_pos()
	
func _reset_pos() -> void:
	position = start_pos
	for i in range(len($Trail.points)):
		$Trail.points[i] = Vector2.ZERO
	
func _player_movement(delta: float) -> void:
	var motion: float = Input.get_axis(player + "_up", player + "_down")
	_move(motion, delta)
	
func _ai_movement(delta: float) -> void:
	if not ball:
		return
	var motion: float = clampf(ball.position.y - position.y, -1.0, 1.0)
	_move(motion, delta)
	
func _move(motion: float, delta: float) -> void:
	for i in range(1, len($Trail.points)):
		$Trail.points[i - 1] = $Trail.points[i] - Vector2(0, motion) * delta * SPEED
	position.y += motion * SPEED * delta
	position.y = clampf(position.y, min_y + (height * 0.5), max_y - (height * 0.5))
