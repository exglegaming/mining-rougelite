extends CanvasLayer


@onready var depth_label: Label = $DepthRect/DepthLabel


func update_depth(value: int) -> void:
    depth_label.text = "Depth: %d" % value
