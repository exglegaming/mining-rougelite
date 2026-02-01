extends Node2D


@onready var level: Level = $Level
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
    # if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
    #     Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

    level.change_depth.connect(hud.update_depth)
