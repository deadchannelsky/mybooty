extends LootItem
class_name Sword

## Sword loot item - long, awkward shape, difficult to balance
## Unique elongated collision shape makes stacking very challenging

func _ready() -> void:
	# Set sword-specific properties
	loot_type = "sword"
	base_score = 35  # High score due to extreme difficulty
	loot_mass = 2.5  # Moderate weight
	loot_friction = 0.6  # Moderate friction
	loot_bounce = 0.1  # Low bounce from metal
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with massive bonus for successful stacking
	var bonus_multiplier: float = 1.0
	
	# Massive bonus for stabilizing this extremely difficult item
	if is_stabilized:
		bonus_multiplier = 2.0
	
	return int(base_score * bonus_multiplier)