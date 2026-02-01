extends Control


func _ready() -> void:
    visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_inventory"):
        visible = !visible
