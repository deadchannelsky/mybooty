extends LootItem
class_name Bottle

## Bottle loot item - tall, narrow, tips easily
## Light weight and high center of gravity make it challenging to balance

func _ready() -> void:
	# Set bottle-specific properties
	loot_type = "bottle"
	base_score = 20  # Moderate score due to difficulty
	loot_mass = 0.3  # Light weight
	loot_friction = 0.7  # Moderate friction
	loot_bounce = 0.3  # Moderate bounce from glass
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with high bonus for successful balancing
	var bonus_multiplier: float = 1.0
	
	# High bonus for stabilizing this tippy item
	if is_stabilized:
		bonus_multiplier = 1.4
	
	return int(base_score * bonus_multiplier)
