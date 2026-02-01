class_name Inventory
extends RefCounted


signal inventory_changed

var slots: Array[InventorySlot] = []
var max_slots: int


func _init(starting_slots: int = 4) -> void:
    max_slots = starting_slots
    for i: int in range(max_slots):
        slots.append(null)


func add_item(data: OreData) -> bool:
    # Try stacking with existing items
    for slot: InventorySlot in slots:
        if slot != null && slot.can_stack(data):
            slot.add_ore()
            inventory_changed.emit()
            return true

    # Find empty slot
    for i: int in range(slots.size()):
        if slots[i] == null:
            slots[i] = InventorySlot.new(data, 1)
            inventory_changed.emit()
            return true
    
    # No space
    return false
