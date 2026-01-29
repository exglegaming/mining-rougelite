extends CharacterBody2D


const SPEED = 100.0


func _physics_process(_delta: float) -> void:
	process_movement()
	move_and_slide()


func process_movement() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
