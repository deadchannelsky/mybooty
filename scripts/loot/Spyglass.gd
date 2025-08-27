extends LootItem
class_name Spyglass

## Spyglass loot item - telescope, long cylindrical shape that rolls easily
## Similar physics to sword but shorter and less awkward

func _ready() -> void:
	# Set spyglass-specific properties
	loot_type = "spyglass" 
	base_score = 35  # High score due to navigation value
	loot_mass = 1.2  # Medium weight from metal and glass
	loot_friction = 0.65  # Lower friction due to smooth metal surface - tends to roll
	loot_bounce = 0.25  # Moderate bounce from metal construction
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with bonus for this navigational instrument
	var bonus_multiplier: float = 1.0
	
	# Bonus for stabilizing this rolling item
	if is_stabilized:
		bonus_multiplier = 1.3
	
	return int(base_score * bonus_multiplier)