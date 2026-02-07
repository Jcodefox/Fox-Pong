extends Area2D

@export var player: String = "p1"
@export var min_y: float = 25.0
@export var max_y: float = 623.0

var height: float

const SPEED = 300

func _ready() -> void:
	height = $CollisionShape2D.shape.size.y

func _physics_process(delta: float) -> void:
	var motion: float = Input.get_axis(player + "_up", player + "_down")
	position.y += motion * SPEED * delta
	position.y = clampf(position.y, min_y + (height * 0.5), max_y - (height * 0.5))
