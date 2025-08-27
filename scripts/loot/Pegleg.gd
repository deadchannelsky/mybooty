extends LootItem
class_name Pegleg

## Pegleg loot item - wooden peg leg, odd vertical shape
## Medium weight with awkward balance characteristics

func _ready() -> void:
	# Set pegleg-specific properties
	loot_type = "pegleg"
	base_score = 20  # Moderate score for this unusual item
	loot_mass = 1.3  # Medium weight from solid wood
	loot_friction = 0.8  # High friction from rough wood surface
	loot_bounce = 0.15  # Low bounce from wood material
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with bonus for this quirky pirate item
	var bonus_multiplier: float = 1.0
	
	# Bonus for balancing this odd-shaped item
	if is_stabilized:
		bonus_multiplier = 1.25
	
	return int(base_score * bonus_multiplier)