extends CharacterBody2D


const SPEED = 100.0

var is_mining: bool = false
var last_direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)


func _physics_process(_delta: float) -> void:
	# Handle mining input
	if Input.is_action_just_pressed("use_pickaxe"):
		use_pickaxe()
	
	# Skip movement if mining
	if is_mining:
		velocity= Vector2.ZERO
		return

	process_movement()	
	process_animation()
	move_and_slide()

# - - - - - - - - - - - - - - - - - - - - - 
# Movement and Animations
# - - - - - - - - - - - - - - - - - - - - - 
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


# - - - - - - - - - - - - - - - - - - - - - 
# Mining
# - - - - - - - - - - - - - - - - - - - - - 
func use_pickaxe() -> void:
	is_mining = true
	play_animation("swing_pickaxe", last_direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_mining:
		is_mining = false
