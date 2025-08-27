extends LootItem
class_name Idol

## Idol loot item - green tiki statue, medium weight with stable base
## Easier to stack due to wide base but valuable for scoring

func _ready() -> void:
	# Set idol-specific properties
	loot_type = "idol"
	base_score = 30  # High score due to mystical value
	loot_mass = 1.5  # Medium-heavy weight from stone
	loot_friction = 0.9  # High friction from rough stone surface
	loot_bounce = 0.05  # Very low bounce from stone material
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with bonus for this valuable artifact
	var bonus_multiplier: float = 1.0
	
	# Standard bonus for mystical artifact
	if is_stabilized:
		bonus_multiplier = 1.2
	
	return int(base_score * bonus_multiplier)