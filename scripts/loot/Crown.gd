extends LootItem
class_name Crown

## Crown loot item - golden crown with jewels, light and awkward to balance
## High value but challenging shape makes it difficult to stack

func _ready() -> void:
	# Set crown-specific properties
	loot_type = "crown"
	base_score = 50  # Very high score - most valuable loot
	loot_mass = 0.7  # Light weight from hollow gold
	loot_friction = 0.6  # Lower friction due to smooth gold surface
	loot_bounce = 0.15  # Low bounce from soft gold
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with high bonus for this royal treasure
	var bonus_multiplier: float = 1.0
	
	# Very high bonus for successfully balancing the crown
	if is_stabilized:
		bonus_multiplier = 1.5
	
	return int(base_score * bonus_multiplier)