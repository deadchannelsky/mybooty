extends LootItem
class_name Map

## Map loot item - treasure map scroll, very light and flat
## Easy to be blown around but provides stable base when flat

func _ready() -> void:
	# Set map-specific properties
	loot_type = "map"
	base_score = 40  # High score for treasure map value
	loot_mass = 0.3  # Very light weight from parchment
	loot_friction = 0.7  # Moderate friction from paper surface
	loot_bounce = 0.02  # Minimal bounce from soft paper
	
	# Call parent setup
	super._ready()

func get_score_value() -> int:
	## Returns high score with bonus for this valuable treasure map
	var bonus_multiplier: float = 1.0
	
	# Good bonus for securing the treasure map
	if is_stabilized:
		bonus_multiplier = 1.4
	
	return int(base_score * bonus_multiplier)