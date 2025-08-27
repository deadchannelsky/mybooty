extends Node2D

## Core game scene that handles the main gameplay loop
## Manages physics, scoring, and game state during active play

@onready var ui: CanvasLayer = $UI
@onready var ship_deck: ShipDeck = $ShipDeck

# Preload loot scenes for spawning
@export var barrel_scene: PackedScene = preload("res://scenes/loot/Barrel.tscn")
@export var cannonball_scene: PackedScene = preload("res://scenes/loot/Cannonball.tscn")
@export var treasure_chest_scene: PackedScene = preload("res://scenes/loot/TreasureChest.tscn")
@export var bottle_scene: PackedScene = preload("res://scenes/loot/Bottle.tscn")
@export var sword_scene: PackedScene = preload("res://scenes/loot/Sword.tscn")
@export var hook_scene: PackedScene = preload("res://scenes/loot/Hook.tscn")
@export var skull_scene: PackedScene = preload("res://scenes/loot/Skull.tscn")
@export var cup_scene: PackedScene = preload("res://scenes/loot/Cup.tscn")
@export var idol_scene: PackedScene = preload("res://scenes/loot/Idol.tscn")
@export var crown_scene: PackedScene = preload("res://scenes/loot/Crown.tscn")
@export var hat_scene: PackedScene = preload("res://scenes/loot/Hat.tscn")
@export var spyglass_scene: PackedScene = preload("res://scenes/loot/Spyglass.tscn")
@export var pegleg_scene: PackedScene = preload("res://scenes/loot/Pegleg.tscn")
@export var map_scene: PackedScene = preload("res://scenes/loot/Map.tscn")

# Loot type weights for random selection (higher = more common)
var loot_weights: Dictionary = {
	"barrel": 3,
	"treasure_chest": 2,
	"bottle": 2,
	"cannonball": 1,
	"skull": 2,
	"hook": 1,
	"sword": 1,  # Rarest due to difficulty
	"cup": 2,
	"idol": 2,
	"crown": 1,  # Rare due to high value
	"hat": 3,  # Common due to light weight
	"spyglass": 1,  # Rare navigational tool
	"pegleg": 2,
	"map": 1  # Rarest due to highest value
}

var score: int = 0
var is_game_active: bool = false
var is_game_paused: bool = false
var active_loot_items: Array[LootItem] = []
var game_over_reason: String = ""
var items_fallen_count: int = 0
var max_fallen_items: int = 3  # Game over after 3 items fall

signal return_to_main_menu

# Input system variables
var next_loot_type: String = ""
var drop_cooldown: float = 0.0
var drop_cooldown_time: float = 0.3  # Prevent spam clicking but allow quick play

func _ready() -> void:
	# Initialize game systems
	setup_ship_deck_signals()
	setup_ui_signals()
	start_game()
	
	# Initialize input system
	setup_input_system()

func _process(delta: float) -> void:
	# Handle drop cooldown
	if drop_cooldown > 0:
		drop_cooldown -= delta
	
	# Monitor stack height if game is active
	if is_game_active:
		check_stack_height()

func _input(event: InputEvent) -> void:
	## Handles all input events for the game
	# Handle global keys regardless of game state
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			restart_game()
			return
		elif event.keycode == KEY_P or event.keycode == KEY_SPACE:
			toggle_pause()
			return
		elif event.keycode == KEY_ESCAPE:
			_on_return_to_menu_requested()
			return
	
	if not is_game_active or is_game_paused:
		return
	
	# Handle tap/click to drop loot
	if event is InputEventScreenTouch:
		if event.pressed and drop_cooldown <= 0:
			handle_tap_to_drop(event.position)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and drop_cooldown <= 0:
			handle_tap_to_drop(event.position)

func setup_ship_deck_signals() -> void:
	## Connects ship deck signals for game state management
	ship_deck.ship_tipped_over.connect(_on_ship_tipped_over)

func setup_ui_signals() -> void:
	## Connects UI signals for game control
	ui.pause_game_requested.connect(_on_pause_game_requested)
	ui.restart_game_requested.connect(_on_restart_game_requested)
	ui.return_to_menu_requested.connect(_on_return_to_menu_requested)

func start_game() -> void:
	## Starts a new game session
	is_game_active = true
	score = 0
	items_fallen_count = 0
	game_over_reason = ""
	print("mybooty game started!")

func end_game() -> void:
	## Ends the current game session with specific reason
	if is_game_active:  # Prevent multiple calls
		is_game_active = false
		is_game_paused = false
		print("Game over! Reason: ", game_over_reason, " | Final score: ", score)
		ui.show_game_over_screen(score, game_over_reason)
		
		# Stop any remaining physics
		for item in active_loot_items:
			if is_instance_valid(item):
				item.freeze = true

func add_score(points: int) -> void:
	## Adds points to the current score
	if is_game_active:
		score += points
		ui.update_score(score)

func setup_input_system() -> void:
	## Initializes the input system and prepares first loot item
	next_loot_type = get_random_loot_type()
	update_loot_preview()
	print("Input system ready - tap to drop ", next_loot_type)

func handle_tap_to_drop(tap_position: Vector2) -> void:
	## Handles tap/click to drop loot at the specified position
	if drop_cooldown > 0:
		return
	
	# Convert screen position to world position
	var world_position: Vector2 = get_global_mouse_position()
	
	# Constrain drop position to be above the ship deck
	var drop_x: float = clamp(world_position.x, 60, 660)  # Keep within screen bounds
	var drop_y: float = 100  # Fixed height above ship
	var drop_position: Vector2 = Vector2(drop_x, drop_y)
	
	# Spawn the loot item
	var spawned_item: LootItem = spawn_loot_item(next_loot_type, drop_position)
	if spawned_item:
		print("Dropped ", next_loot_type, " at ", drop_position)
		
		# Set cooldown to prevent spam
		drop_cooldown = drop_cooldown_time
		
		# Generate next loot type
		next_loot_type = get_random_loot_type()
		
		# Update UI preview (will implement later)
		update_loot_preview()

func spawn_loot_item(loot_type: String, position: Vector2) -> LootItem:
	## Spawns a loot item at the specified position
	var loot_item: LootItem = null
	
	match loot_type:
		"barrel":
			loot_item = barrel_scene.instantiate() as LootItem
		"cannonball":
			loot_item = cannonball_scene.instantiate() as LootItem
		"treasure_chest":
			loot_item = treasure_chest_scene.instantiate() as LootItem
		"bottle":
			loot_item = bottle_scene.instantiate() as LootItem
		"sword":
			loot_item = sword_scene.instantiate() as LootItem
		"hook":
			loot_item = hook_scene.instantiate() as LootItem
		"skull":
			loot_item = skull_scene.instantiate() as LootItem
		"cup":
			loot_item = cup_scene.instantiate() as LootItem
		"idol":
			loot_item = idol_scene.instantiate() as LootItem
		"crown":
			loot_item = crown_scene.instantiate() as LootItem
		"hat":
			loot_item = hat_scene.instantiate() as LootItem
		"spyglass":
			loot_item = spyglass_scene.instantiate() as LootItem
		"pegleg":
			loot_item = pegleg_scene.instantiate() as LootItem
		"map":
			loot_item = map_scene.instantiate() as LootItem
		_:
			print("Unknown loot type: ", loot_type)
			return null
	
	if loot_item:
		# Add to scene and configure
		add_child(loot_item)
		loot_item.global_position = position
		active_loot_items.append(loot_item)
		
		# Connect loot item signals
		loot_item.item_dropped.connect(_on_loot_item_dropped)
		loot_item.item_stabilized.connect(_on_loot_item_stabilized)
		loot_item.item_fell_off_ship.connect(_on_loot_item_fell_off_ship)
		
		print("Spawned ", loot_type, " at ", position)
	
	return loot_item

func _on_loot_item_dropped(item: LootItem) -> void:
	## Handles when loot item lands on ship deck
	ship_deck.add_loot_item(item)
	print("Loot item landed on deck: ", item.loot_type)

func _on_loot_item_stabilized(item: LootItem) -> void:
	## Handles when loot item becomes stable (awards score)
	if is_game_active:
		var points: int = item.get_score_value()
		add_score(points)
		print("Loot stabilized, awarded ", points, " points")

func _on_loot_item_fell_off_ship(item: LootItem) -> void:
	## Handles when loot item falls off the ship
	ship_deck.remove_loot_item(item)
	active_loot_items.erase(item)
	items_fallen_count += 1
	item.queue_free()
	print("Loot item fell off ship: ", item.loot_type, " (Total fallen: ", items_fallen_count, "/", max_fallen_items, ")")
	
	# Update UI with fallen items warning
	ui.update_fallen_items_warning(items_fallen_count, max_fallen_items)
	
	# Check for game over conditions
	if items_fallen_count >= max_fallen_items:
		game_over_reason = "Too many items fell overboard!"
		end_game()
	elif active_loot_items.size() == 0 and items_fallen_count > 0:
		game_over_reason = "All loot lost at sea!"
		end_game()

func _on_ship_tipped_over(angle: float) -> void:
	## Handles when ship tips over too far
	game_over_reason = "Ship tipped over! (" + str(int(angle)) + "°)"
	print("Ship tipped over! Angle: ", angle, " degrees")
	end_game()

func get_random_loot_type() -> String:
	## Returns a random loot type based on weighted selection
	var total_weight: int = 0
	for weight in loot_weights.values():
		total_weight += weight
	
	var random_value: int = randi() % total_weight
	var current_weight: int = 0
	
	for loot_type in loot_weights.keys():
		current_weight += loot_weights[loot_type]
		if random_value < current_weight:
			return loot_type
	
	return "barrel"  # Fallback

func update_loot_preview() -> void:
	## Updates the UI to show the next loot item to drop
	ui.update_next_loot_preview(next_loot_type)
	print("Next loot item: ", next_loot_type)

func restart_game() -> void:
	## Restarts the game by clearing everything and starting fresh
	print("Restarting game...")
	
	# Hide game over screen
	ui.hide_game_over_screen()
	
	# Clear all active loot items
	for item in active_loot_items:
		if is_instance_valid(item):
			item.queue_free()
	active_loot_items.clear()
	
	# Reset ship deck
	ship_deck.loot_items_on_deck.clear()
	ship_deck.current_load = 0.0
	
	# Reset game state
	start_game()
	
	# Reset input system
	setup_input_system()

func check_stack_height() -> void:
	## Checks if the loot stack is getting dangerously high
	var highest_item_y: float = 9999.0
	for item in active_loot_items:
		if is_instance_valid(item) and item.global_position.y < highest_item_y:
			highest_item_y = item.global_position.y
	
	# If stack reaches too high (top 10% of screen), warn player
	var danger_height: float = 200.0  # Adjust based on screen size
	if highest_item_y < danger_height and active_loot_items.size() > 5:
		ui.show_height_warning(true)
	else:
		ui.show_height_warning(false)

func toggle_pause() -> void:
	## Toggles game pause state
	if not is_game_active:
		return
	
	is_game_paused = not is_game_paused
	get_tree().paused = is_game_paused
	
	if is_game_paused:
		print("Game paused - Press P or Space to resume")
	else:
		print("Game resumed")

func _on_pause_game_requested() -> void:
	## Handles pause button press from UI
	toggle_pause()

func _on_restart_game_requested() -> void:
	## Handles restart button press from UI
	restart_game()

func _on_return_to_menu_requested() -> void:
	## Handles return to menu request from UI
	print("Returning to main menu...")
	return_to_main_menu.emit()
