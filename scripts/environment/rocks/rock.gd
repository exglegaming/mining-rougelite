class_name Rock
extends StaticBody2D

const ORE_SCENE: PackedScene = preload("uid://dvuahlhdvex0f")


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
        _drop_ore()
        _destroy()


func _destroy() -> void:
    queue_free()


func _drop_ore() -> void:
    var ore: Ore = ORE_SCENE.instantiate()
    ore.position = position
    ore.ore_data = data.ore_resource
    
    var level_root: Node2D = get_parent().get_parent()
    var ore_container: Node2D = level_root.get_node("OreContainer")
    ore_container.add_child(ore)
