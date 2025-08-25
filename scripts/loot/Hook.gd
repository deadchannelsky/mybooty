extends LootItem
class_name Hook

## Hook loot item - curved shape, moderate difficulty
## Awkward shape but lighter than sword

func _ready() -> void:
	# Set hook-specific properties
	loot_type = "hook"
	base_score = 18
	loot_mass = 1.5
	loot_friction = 0.7
	loot_bounce = 0.15
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	var bonus_multiplier: float = 1.0
	if is_stabilized:
		bonus_multiplier = 1.3
	return int(base_score * bonus_multiplier)