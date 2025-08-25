extends LootItem
class_name Skull

## Skull loot item - round shape, moderate stability
## Light but decent balance

func _ready() -> void:
	# Set skull-specific properties
	loot_type = "skull"
	base_score = 22
	loot_mass = 1.2
	loot_friction = 0.8
	loot_bounce = 0.2
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	var bonus_multiplier: float = 1.0
	if is_stabilized:
		bonus_multiplier = 1.2
	return int(base_score * bonus_multiplier)