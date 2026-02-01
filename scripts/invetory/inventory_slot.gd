class_name InventorySlot
extends RefCounted


const STACK_SIZE: int = 5

var ore_data: OreData
var quantity: int = 0


func _init(data: OreData, qty: int) -> void:
    ore_data = data
    qty = qty


func can_stack(data: OreData) -> bool:
    return ore_data.name == data.name and quantity < STACK_SIZE


func add_ore() -> void:
    quantity += 1
