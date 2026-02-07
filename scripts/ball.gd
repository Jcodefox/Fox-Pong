extends Area2D

var spawn_point: Vector2 = Vector2.ZERO
var speed: float = 400
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	spawn_point = global_position
	randomize_direction()

func randomize_direction() -> void:
	var direction_angle: float = randf_range(-TAU * 0.17, TAU * 0.17)
	direction = Vector2(cos(direction_angle), sin(direction_angle))
	if randi_range(0, 1) == 0:
		direction.x = -direction.x
	

func _physics_process(delta: float) -> void:
	for i in range(1, len($Trail.points)):
		$Trail.points[i - 1] = $Trail.points[i] - direction.normalized() * delta * speed
	position += direction.normalized() * delta * speed

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("paddle"):
		direction.x = -direction.x
		var paddle_height: float = area.height
		var weight: float = (area.position.y - position.y) / (paddle_height * 0.5)
		direction = direction.lerp(Vector2.UP, weight * 0.5)
	elif area.is_in_group("wall"):
		direction.y = -direction.y
	else:
		global_position = spawn_point
		randomize_direction()
		if area.is_in_group("p1_goal"):
			get_tree().current_scene.p2_score += 1
		else:
			get_tree().current_scene.p1_score += 1
