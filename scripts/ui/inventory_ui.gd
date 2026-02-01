class_name InventoryUI
extends Control


const SLOT_SCENE: PackedScene = preload("uid://d2m5edvbek8mb")

var inventory: Inventory

@onready var grid_container: GridContainer = $GridContainer


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = !visible


func set_inventory(inv: Inventory) -> void:
	inventory = inv
	inventory.inventory_changed.connect(_update_display)
	_update_display()


func _update_display() -> void:
	# Clear existing slot UI
	for child: Node in grid_container.get_children():
		child.queue_free()
	
	# Create UI for each inventory slot
	for slot: InventorySlot in inventory.slots:
		var slot_ui = create_slot_ui(slot)
		grid_container.add_child(slot_ui)


func create_slot_ui(slot: InventorySlot) -> TextureRect:
	var slot_ui: TextureRect = SLOT_SCENE.instantiate()
	var margin_container: MarginContainer = slot_ui.get_node("MarginContainer")
	var icon: TextureRect = margin_container.get_node("ItemIcon")
	var quantity_label: Label = slot_ui.get_node("QuantityLabel")
	
	if slot != null:
		icon.texture = slot.ore_data.texture
		quantity_label.text = "x%d" % slot.quantity
		quantity_label.visible = true
	else:
		icon.texture = null
		quantity_label.visible = false
	
	return slot_ui
