extends LootItem
class_name Barrel

## Barrel loot item - medium size, stable stacking properties
## Represents a balanced loot type with moderate weight and good stability

func _ready() -> void:
	# Set barrel-specific properties
	loot_type = "barrel"
	base_score = 15
	loot_mass = 2.0      # Medium weight
	loot_friction = 0.9  # High friction for stability
	loot_bounce = 0.05   # Very low bounce
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with potential bonus for stable placement
	var bonus_multiplier: float = 1.0
	
	# Bonus for being stabilized
	if is_stabilized:
		bonus_multiplier = 1.2
	
	return int(base_score * bonus_multiplier)
