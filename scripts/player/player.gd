extends CharacterBody2D


const SPEED = 100.0

var is_mining: bool = false
var hitbox_offset: Vector2
var last_direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D


func _ready() -> void:
	hitbox_offset = hitbox.position # Initialize hitbox offset

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
		update_hitbox_position()
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
# Hitbox Offset
# - - - - - - - - - - - - - - - - - - - - - 
func update_hitbox_position() -> void:
	var x: float = hitbox_offset.x
	var y: float = hitbox_offset.y

	match last_direction:
		Vector2.LEFT:
			hitbox.position = Vector2(-x, y)
			hitbox_collision_shape_2d.rotation_degrees = 0
		Vector2.RIGHT:
			hitbox.position = Vector2(x, y)
			hitbox_collision_shape_2d.rotation_degrees = 0
		Vector2.UP:
			hitbox.position = Vector2(y, -x)
			hitbox_collision_shape_2d.rotation_degrees = 90
		Vector2.DOWN:
			hitbox.position = Vector2(y, x)
			hitbox_collision_shape_2d.rotation_degrees = 90


# - - - - - - - - - - - - - - - - - - - - - 
# Mining
# - - - - - - - - - - - - - - - - - - - - - 
func use_pickaxe() -> void:
	is_mining = true
	play_animation("swing_pickaxe", last_direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_mining:
		is_mining = false
