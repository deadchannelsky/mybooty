extends LootItem
class_name Cannonball

## Cannonball loot item - small, heavy, and rolls easily
## High mass but unstable due to round shape - challenging to stack

func _ready() -> void:
	# Set cannonball-specific properties
	loot_type = "cannonball"
	base_score = 25  # Higher score due to difficulty
	loot_mass = 6.0  # Heavy for its size
	loot_friction = 0.3  # Low friction - rolls easily
	loot_bounce = 0.2  # Moderate bounce
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with bonus for successful stacking despite instability
	var bonus_multiplier: float = 1.0
	
	# Large bonus for stabilizing this difficult item
	if is_stabilized:
		bonus_multiplier = 1.5
	
	return int(base_score * bonus_multiplier)