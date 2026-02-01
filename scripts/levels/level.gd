class_name Level
extends Node2D


signal change_depth(depth: int)

const FILL_PERCENTAGE: float = 0.4
const LADDER_CHANCE: float = 1.0 # If not set to 0.2 change back when game is complete
const ROCK_SCENE: PackedScene = preload("uid://c71x830xiqkhn")
const LADDER_SCENE: PackedScene = preload("uid://d4aer8gboafqq")
const MAPS: Array[PackedScene] = [
	preload("uid://p6heen7ubb7u"),
	preload("uid://2mwwbmb8i16g"),
	preload("uid://dvi1ngg2nodik")
]

@export var rock_types: Array[RockData]

var last_map_index: int
var current_depth: int = 1
var down_ladder: Ladder
var rocks_remaining: int = 0

@onready var rock_container: Node2D = $RockContainer
@onready var ore_container: Node2D = $OreContainer
@onready var current_map: Node2D = $Map
@onready var player: Player = $Player


func _ready() -> void:
	setup_map()


func setup_map() -> void:
	_clear_map()
	_generate_map()
	_generate_rocks()
	_position_object()


func _clear_map() -> void:
	# Remove old map
	if current_map:
		current_map.queue_free()
		current_map = null
	
	# Delete any down ladders
	if down_ladder:
		down_ladder.queue_free()
		down_ladder = null
	
	# Clear existing rocks
	for child in rock_container.get_children():
		child.queue_free()
	
	# Delete any ores not collected
	for ore: Node in ore_container.get_children():
		ore.queue_free()


func _generate_map() -> void:
	# Pick a random map
	var new_index: int = randi_range(0, MAPS.size() - 1)

	# Keep picking until we get a different one
	while new_index == last_map_index:
		new_index = randi_range(0, MAPS.size() - 1)
	last_map_index = new_index

	current_map = MAPS[new_index].instantiate()
	self.add_child(current_map)


func _position_object() -> void:
	var player_spawn: Marker2D = current_map.get_node("PlayerSpawn")
	player.reset(player_spawn.position)


func _generate_rocks() -> void:   
	# Get tilemap layers from current map
	var ground_layer: TileMapLayer = current_map.get_node("Ground")
	var props_layer: TileMapLayer = current_map.get_node("Props")
	var ground_cells: Array[Vector2i] = ground_layer.get_used_cells()
	var available_cells: Array = []

	for cell: Vector2i in ground_cells:
		# Get the tile data for this specific coordinate
		var tile_data: TileData = ground_layer.get_cell_tile_data(cell)

		# Check if there are any props in the way
		# get_cell_source_id returns -1 if the cell is empty
		if props_layer.get_cell_source_id(cell) != -1:
			continue

		# Check if this tile has the 'can_spawn_rocks' property set to true
		if tile_data and tile_data.get_custom_data("can_spawn_rocks") == true:
			available_cells.append(cell) 
	
	available_cells.shuffle()

	var num_rocks: int = int(available_cells.size() * FILL_PERCENTAGE)
	rocks_remaining = num_rocks

	var valid_rocks: Array[RockData] = []
	for rock: RockData in rock_types:
		if current_depth >= rock.min_depth:
			valid_rocks.append(rock)

	for i: int in range(num_rocks):
		var cell = available_cells[i]
		var rock: Rock = ROCK_SCENE.instantiate()

		rock.data = get_random_rock(valid_rocks)

		# Get local position from tilemap
		var local_position: Vector2 = ground_layer.map_to_local(cell)

		rock.global_position = local_position
		rock_container.add_child(rock)
		rock.broken.connect(_on_rock_broken)


func get_random_rock(options: Array[RockData]) -> RockData:
	var total_weight: int = 0
	for rock: RockData in options:
		total_weight += rock.rarity
	
	var roll: int = randi_range(0, total_weight - 1)
	var current_sum: int = 0

	for rock: RockData in options:
		current_sum += rock.rarity
		if roll < current_sum:
			return rock
	
	return options[0] # Fallback to stone if nothing else is picked randomly


func _on_rock_broken(pos: Vector2) -> void:
	rocks_remaining -= 1
	if down_ladder != null: return

	var drop_ladder: bool = randf() < LADDER_CHANCE
	if drop_ladder || rocks_remaining == 0:
		_create_down_ladder(pos)


func _create_down_ladder(pos: Vector2) -> void:
	down_ladder = LADDER_SCENE.instantiate()
	down_ladder.position = pos
	add_child(down_ladder)
	down_ladder.ladder_used.connect(_on_down_ladder_used)


func _on_down_ladder_used() -> void:
	current_depth += 1
	change_depth.emit(current_depth)
	setup_map()
