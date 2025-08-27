extends LootItem
class_name Cup

## Cup loot item - golden chalice, light and tippy
## Similar physics to bottle but slightly more stable due to wider base

func _ready() -> void:
	# Set cup-specific properties
	loot_type = "cup"
	base_score = 25  # Higher score due to rarity and balance difficulty
	loot_mass = 0.8  # Light weight like bottle
	loot_friction = 0.75  # Moderate friction from metal
	loot_bounce = 0.2  # Low bounce from gold material
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with bonus for successful balancing
	var bonus_multiplier: float = 1.0
	
	# Bonus for stabilizing this valuable item
	if is_stabilized:
		bonus_multiplier = 1.3
	
	return int(base_score * bonus_multiplier)