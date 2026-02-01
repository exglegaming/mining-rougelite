class_name ExitLadder
extends Area2D

signal ladder_used

var player_on_exit_ladder: bool = false


func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("climb_exit_ladder"):
        if player_on_exit_ladder:
            ladder_used.emit()


func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        player_on_exit_ladder = true
       


func _on_body_exited(body: Node2D) -> void:
    if body is Player:
        player_on_exit_ladder = false

