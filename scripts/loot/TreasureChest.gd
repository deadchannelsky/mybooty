extends LootItem
class_name TreasureChest

## Treasure Chest loot item - large, rectangular, very stable base
## High mass and excellent stability make it ideal for foundation pieces

func _ready() -> void:
	# Set treasure chest-specific properties
	loot_type = "treasure_chest"
	base_score = 30  # High score for valuable treasure
	loot_mass = 4.0  # Heavy due to treasure contents
	loot_friction = 1.0  # High friction for stability
	loot_bounce = 0.0  # No bounce - solid and stable
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns score with foundation bonus for supporting other items
	var bonus_multiplier: float = 1.0
	
	# Bonus for being stabilized
	if is_stabilized:
		bonus_multiplier = 1.1
	
	return int(base_score * bonus_multiplier)