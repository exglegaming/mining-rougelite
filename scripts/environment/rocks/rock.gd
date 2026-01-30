class_name Rock
extends StaticBody2D


@export var data: RockData

var health: int

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
    health = data.max_health
    sprite_2d.texture = data.texture


func take_damage(amount: int) -> void:
    health -= amount
    print(health)
    if health <= 0:
        _destroy()


func _destroy() -> void:
    queue_free()
