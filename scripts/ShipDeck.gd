extends StaticBody2D
class_name ShipDeck

## Ship deck platform that serves as the base for stacking loot
## Handles ship rocking motion and collision detection with loot items

signal ship_tipped_over(angle: float)

@export var max_tilt_angle: float = 25.0  # Maximum tilt before game over
@export var rocking_speed: float = 1.0    # Speed of ship rocking motion
@export var rocking_amplitude: float = 3.0 # Amplitude of rocking in degrees

var base_rotation: float = 0.0
var current_load: float = 0.0
var max_safe_load: float = 100.0
var loot_items_on_deck: Array[LootItem] = []

func _ready() -> void:
	# Configure collision properties for ship deck
	setup_collision_properties()
	
	# Set initial position in scene
	global_position = Vector2(360, 1000)  # Center bottom of screen

func setup_collision_properties() -> void:
	## Configures collision layer for ship deck interaction
	# Layer 2: Ship deck
	collision_layer = 2
	collision_mask = 0  # Static body doesn't need to detect collisions
	
	# Configure physics material for deck surface
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = 1.0  # High friction to prevent sliding
	physics_material_override.bounce = 0.0    # No bounce for stable platform

func _physics_process(delta: float) -> void:
	# Apply gentle rocking motion
	apply_rocking_motion(delta)
	
	# Check for dangerous tilt angles
	check_tilt_stability()

func apply_rocking_motion(delta: float) -> void:
	## Applies gentle rocking motion to simulate ship on water
	# Use engine time for consistent physics-friendly timing
	var time: float = Time.get_ticks_msec() / 1000.0
	
	# Calculate base rocking motion (gentle sine wave)
	var rocking_offset: float = sin(time * rocking_speed) * rocking_amplitude
	
	# Add load-based tilting
	var load_tilt: float = calculate_load_tilt()
	
	# Apply combined rotation (smooth interpolation to prevent physics jitter)
	var target_rotation: float = base_rotation + rocking_offset + load_tilt
	rotation_degrees = lerp(rotation_degrees, target_rotation, delta * 2.0)

func calculate_load_tilt() -> float:
	## Calculates additional tilt based on loot distribution and weight
	if loot_items_on_deck.size() == 0:
		return 0.0
	
	var weight_distribution: float = 0.0
	var total_weight: float = 0.0
	
	# Calculate center of mass relative to deck center
	for item in loot_items_on_deck:
		if is_instance_valid(item):
			var relative_position: float = item.global_position.x - global_position.x
			var item_weight: float = item.loot_mass
			weight_distribution += relative_position * item_weight
			total_weight += item_weight
	
	if total_weight > 0:
		# Calculate tilt based on weight distribution
		var center_of_mass_offset: float = weight_distribution / total_weight
		return (center_of_mass_offset / 300.0) * 15.0  # Scale to reasonable tilt
	
	return 0.0

func check_tilt_stability() -> void:
	## Monitors ship tilt angle and triggers game over if too steep
	var current_angle: float = abs(rotation_degrees)
	
	if current_angle > max_tilt_angle:
		ship_tipped_over.emit(current_angle)

func add_loot_item(item: LootItem) -> void:
	## Registers a loot item as being on the deck
	if item not in loot_items_on_deck:
		loot_items_on_deck.append(item)
		current_load += item.loot_mass

func remove_loot_item(item: LootItem) -> void:
	## Removes a loot item from deck tracking
	if item in loot_items_on_deck:
		loot_items_on_deck.erase(item)
		current_load -= item.loot_mass

func get_deck_bounds() -> Rect2:
	## Returns the bounds of the ship deck for spawn positioning
	var deck_width: float = 600.0
	var deck_height: float = 40.0
	return Rect2(
		global_position.x - deck_width/2,
		global_position.y - deck_height/2,
		deck_width,
		deck_height
	)
