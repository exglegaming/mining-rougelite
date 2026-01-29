extends StaticBody2D


@export var data: RockData

var health: int

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
    health = data.max_health
    sprite_2d.texture = data.texture
