class_name Rock
extends StaticBody2D


signal broken(pos: Vector2)

const ORE_SCENE: PackedScene = preload("uid://dvuahlhdvex0f")
const FLASH_COLOR: Color = Color(2.454, 2.454, 2.454)


@export var data: RockData

var health: int

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rock_breaking_sound: AudioStreamPlayer2D = $RockBreakingSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
    health = data.max_health
    sprite_2d.texture = data.texture


func take_damage(amount: int) -> void:
    health -= amount
    _flash()
    if health <= 0:
        _drop_ore()
        _destroy()


func _flash() -> void:
    sprite_2d.modulate = FLASH_COLOR
    var tween: Tween = create_tween()
    tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.1)


func _destroy() -> void:
    # Hide rock
    visible = false
    collision_shape_2d.set_deferred("disabled", true)

    rock_breaking_sound.play()
    await rock_breaking_sound.finished
    queue_free()


func _drop_ore() -> void:
    broken.emit(position)

    var ore: Ore = ORE_SCENE.instantiate()
    ore.position = position
    ore.ore_data = data.ore_resource
    
    var level_root: Node2D = get_parent().get_parent()
    var ore_container: Node2D = level_root.get_node("OreContainer")
    ore_container.add_child(ore)

    # Random horizontal offset
    var random_x: float = randf_range(-15, 15)
    var target_x: float = ore.position.x + random_x

    var tween: Tween = ore.create_tween()
    tween.set_parallel(true) # Run tweens simultaneously

    # Vertical bounce
    tween.tween_property(ore, "position:y", ore.position.y - 20, 0.3)\
        .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
    tween.tween_property(ore, "position:y", ore.position.y, 0.3)\
        .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(0.3)

    # Horizontal bounce
    tween.tween_property(ore, "position:x", target_x, 0.6)\
        .set_ease(Tween.EASE_OUT)
