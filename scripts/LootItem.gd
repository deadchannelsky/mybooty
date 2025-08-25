extends RigidBody2D
class_name LootItem

## Base class for all loot items in the game
## Handles physics properties, scoring, and collision detection for stacked items

signal item_dropped(item: LootItem)
signal item_stabilized(item: LootItem)
signal item_fell_off_ship(item: LootItem)

@export var loot_type: String = "generic"
@export var base_score: int = 10
@export var loot_mass: float = 1.0
@export var loot_friction: float = 0.8
@export var loot_bounce: float = 0.1

var is_stabilized: bool = false
var fall_timer: float = 0.0
var velocity_threshold: float = 5.0
var stability_time: float = 1.0

func _ready() -> void:
	# Configure physics properties for stable stacking
	setup_physics_properties()
	setup_collision_detection()
	
	# Connect physics signals
	body_entered.connect(_on_collision_detected)
	sleeping_state_changed.connect(_on_sleeping_state_changed)

func setup_physics_properties() -> void:
	## Configures physics properties optimized for stacking gameplay
	mass = loot_mass
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = loot_friction
	physics_material_override.bounce = loot_bounce
	
	# Improve stability for stacking
	gravity_scale = 1.0
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
	can_sleep = true

func setup_collision_detection() -> void:
	## Sets up collision layers and masks for proper physics interaction
	# Layer 1: Loot items
	# Layer 2: Ship deck
	collision_layer = 1
	collision_mask = 3  # Collide with loot items (1) and ship deck (2)

func _physics_process(delta: float) -> void:
	# Check if item has fallen off the ship
	check_fall_off_ship()
	
	# Monitor stability for scoring
	monitor_stability(delta)

func check_fall_off_ship() -> void:
	## Detects when loot item falls off the ship deck
	# Check if item is below screen or far from ship deck
	var screen_bottom: float = 1400.0
	var ship_deck_x: float = 360.0  # Ship deck center X position
	var max_distance_from_ship: float = 500.0
	
	# Fall off due to going below screen
	if global_position.y > screen_bottom:
		item_fell_off_ship.emit(self)
		return
	
	# Fall off due to being too far horizontally from ship
	var distance_from_ship: float = abs(global_position.x - ship_deck_x)
	if distance_from_ship > max_distance_from_ship and global_position.y > 800:
		item_fell_off_ship.emit(self)

func monitor_stability(delta: float) -> void:
	## Monitors item stability for scoring and game state
	var current_velocity: float = linear_velocity.length()
	
	if current_velocity < velocity_threshold:
		fall_timer += delta
		if fall_timer >= stability_time and not is_stabilized:
			is_stabilized = true
			item_stabilized.emit(self)
	else:
		fall_timer = 0.0
		is_stabilized = false

func _on_collision_detected(body: Node) -> void:
	## Handles collision events with other physics bodies
	if body is LootItem:
		# Handle loot-to-loot collision
		pass
	elif body.is_in_group("ship_deck"):
		# Handle collision with ship deck
		item_dropped.emit(self)

func _on_sleeping_state_changed() -> void:
	## Called when the rigid body enters or exits sleep state
	if sleeping:
		# Item has come to rest
		is_stabilized = true
		item_stabilized.emit(self)

func get_score_value() -> int:
	## Returns the score value for this loot item
	return base_score
