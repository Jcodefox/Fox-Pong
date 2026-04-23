extends Area2D

@export var camera: Camera2D
var spawn_point: Vector2 = Vector2.ZERO
var speed: float = 400
var direction: Vector2 = Vector2.RIGHT
var time: float = 0.0

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
	$Trail2.position.x = cos(time * 10) * 10
	$Trail2.position.y = sin(time * 10) * 10
	for i in range(1, len($Trail2.points)):
		$Trail2.points[i - 1] = $Trail2.points[i] - direction.normalized() * delta * speed
	$Trail3.position.x = cos(-time * 10) * 10
	$Trail3.position.y = sin(-time * 10) * 10
	for i in range(1, len($Trail3.points)):
		$Trail3.points[i - 1] = $Trail3.points[i] - direction.normalized() * delta * speed
		
	position += direction.normalized() * delta * speed
	time += delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("paddle"):
		direction.x = -direction.x
		camera.shake(Vector2.RIGHT * 4, 25, 0.1)
		var paddle_height: float = area.height
		var weight: float = (area.position.y - position.y) / (paddle_height * 0.5)
		direction = direction.lerp(Vector2.UP, weight * 0.5)
		$HitParticles.restart()
		$Paddle.play()
	elif area.is_in_group("wall"):
		direction.y = -direction.y
		camera.shake(Vector2.UP * 3, 25, 0.1)
		$HitParticles.restart()
		$Wall.play()
	else:
		for i in range(len($Trail.points)):
			$Trail.points[i] = Vector2.ZERO
		for i in range(len($Trail2.points)):
			$Trail2.points[i] = Vector2.ZERO
		for i in range(len($Trail3.points)):
			$Trail3.points[i] = Vector2.ZERO
		camera.shake(Vector2.RIGHT * 15, 25, 0.1)
		global_position = spawn_point
		randomize_direction()
		if area.is_in_group("p1_goal"):
			get_tree().current_scene.p2_score += 1
		else:
			get_tree().current_scene.p1_score += 1
		$Lose.play()
