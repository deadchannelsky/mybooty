extends LootItem
class_name Hat

## Hat loot item - pirate hat with skull, very light and flat profile  
## Easy to knock over but provides stable base when flat

func _ready() -> void:
	# Set hat-specific properties  
	loot_type = "hat"
	base_score = 15  # Lower score due to lighter weight and stability
	loot_mass = 0.5  # Very light weight from fabric
	loot_friction = 0.85  # High friction from fabric texture
	loot_bounce = 0.05  # Very low bounce from soft material
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns base score with small bonus
	var bonus_multiplier: float = 1.0
	
	# Small bonus for cloth item
	if is_stabilized:
		bonus_multiplier = 1.1
	
	return int(base_score * bonus_multiplier)