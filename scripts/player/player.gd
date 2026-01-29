extends CharacterBody2D


const SPEED = 100.0

var last_direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	process_movement()	
	process_animation()
	move_and_slide()


func process_movement() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO


func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)


func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play("%s_right" % prefix)
	elif dir.y < 0:
		animated_sprite_2d.play("%s_up" % prefix)
	elif dir.y > 0:
		animated_sprite_2d.play("%s_down" % prefix)
