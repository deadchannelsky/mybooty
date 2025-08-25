extends Control
class_name OceanBackground

## Ocean background that provides a scenic backdrop for the pirate ship
## Creates a simple animated ocean with gradient colors and subtle wave motion

@onready var ocean_gradient: ColorRect = $OceanGradient

var wave_time: float = 0.0
var wave_speed: float = 0.5
var base_ocean_color: Color = Color(0.1, 0.3, 0.8, 1.0)
var wave_color_variance: float = 0.1

func _ready() -> void:
	# Initialize ocean colors
	setup_ocean_colors()

func setup_ocean_colors() -> void:
	## Sets up the ocean gradient colors for a realistic water appearance
	ocean_gradient.color = base_ocean_color

func _process(delta: float) -> void:
	# Animate subtle color variation to simulate water movement
	animate_water_color(delta)

func animate_water_color(delta: float) -> void:
	## Creates subtle color animation to simulate moving water
	wave_time += delta * wave_speed
	
	# Calculate subtle color variation
	var color_offset: float = sin(wave_time) * wave_color_variance
	var animated_color: Color = base_ocean_color
	animated_color.g += color_offset * 0.5
	animated_color.b += color_offset
	
	ocean_gradient.color = animated_color
