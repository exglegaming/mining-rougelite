class_name HUD
extends CanvasLayer


@onready var depth_label: Label = $DepthRect/DepthLabel
@onready var inventory_ui: InventoryUI = $InventoryUI


func set_inventory(inv: Inventory) -> void:
    inventory_ui.set_inventory(inv)


func update_depth(value: int) -> void:
    depth_label.text = "Depth: %d" % value
