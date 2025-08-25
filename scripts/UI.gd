extends CanvasLayer

## UI manager that handles all user interface elements
## Displays score, game state indicators, and menu screens

@onready var score_label: Label = $ScoreLabel
@onready var next_loot_sprite: Sprite2D = $NextLootContainer/NextLootSprite
@onready var pause_button: Button = $PauseButton
@onready var warning_label: Label = $WarningLabel
@onready var game_over_container: Control = $GameOverContainer
@onready var reason_label: Label = $GameOverContainer/GameOverPanel/GameOverVBox/ReasonLabel
@onready var final_score_label: Label = $GameOverContainer/GameOverPanel/GameOverVBox/FinalScoreLabel
@onready var restart_button: Button = $GameOverContainer/GameOverPanel/GameOverVBox/RestartButton
@onready var menu_button: Button = $GameOverContainer/GameOverPanel/GameOverVBox/MenuButton

signal pause_game_requested
signal restart_game_requested
signal return_to_menu_requested

# Loot sprite texture and regions
var loot_texture: Texture2D = preload("res://art/loot_sprites.png")
var loot_sprite_regions: Dictionary = {
	"barrel": Rect2(528, 284, 170, 207),
	"cannonball": Rect2(291, 284, 183, 178),
	"treasure_chest": Rect2(480, 150, 80, 80),
	"bottle": Rect2(530, 29, 154, 246),
	"sword": Rect2(23, 24, 222, 238),
	"hook": Rect2(528, 33, 164, 240),
	"skull": Rect2(755, 491, 178, 196)
	}

func _ready() -> void:
	# Initialize UI elements
	update_score(0)
	
	# Connect button signals
	pause_button.pressed.connect(_on_pause_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)

func update_score(new_score: int) -> void:
	## Updates the score display with the current score value
	score_label.text = "💰 Treasure: " + str(new_score)

func update_next_loot_preview(loot_type: String) -> void:
	## Updates the preview sprite to show the next loot item
	if loot_type in loot_sprite_regions:
		next_loot_sprite.texture = loot_texture
		next_loot_sprite.region_enabled = true
		next_loot_sprite.region_rect = loot_sprite_regions[loot_type]
		next_loot_sprite.scale = Vector2(0.5, 0.5)  # Scale to 50% of original size
	else:
		print("Unknown loot type for preview: ", loot_type)

func show_game_over_screen(final_score: int, reason: String) -> void:
	## Displays visual game over screen with restart options
	reason_label.text = reason
	final_score_label.text = "Final Score: " + str(final_score)
	game_over_container.visible = true
	restart_button.grab_focus()
	
	print("\n=== GAME OVER ===")
	print("Reason: ", reason)
	print("Final Score: ", final_score)
	print("================\n")

func hide_game_over_screen() -> void:
	## Hides the game over screen
	game_over_container.visible = false

func update_fallen_items_warning(fallen_count: int, max_fallen: int) -> void:
	## Shows warning when items are falling off ship
	var remaining: int = max_fallen - fallen_count
	if remaining > 0:
		warning_label.text = "WARNING! " + str(fallen_count) + " items lost! " + str(remaining) + " remaining!"
		show_warning_popup()
		print("WARNING: ", fallen_count, " items lost! ", remaining, " remaining before game over!")

func show_height_warning(show: bool) -> void:
	## Shows/hides warning when stack is getting dangerously high
	if show:
		warning_label.text = "CAUTION: Stack is getting very tall!"
		show_warning_popup()
	else:
		hide_warning_popup()

func show_warning_popup() -> void:
	## Shows warning label temporarily
	warning_label.visible = true
	# Auto-hide after 3 seconds
	get_tree().create_timer(3.0).timeout.connect(hide_warning_popup)

func hide_warning_popup() -> void:
	## Hides warning label
	warning_label.visible = false

func _on_pause_button_pressed() -> void:
	## Handles pause button press
	pause_game_requested.emit()

func _on_restart_button_pressed() -> void:
	## Handles restart button press
	restart_game_requested.emit()

func _on_menu_button_pressed() -> void:
	## Handles return to menu button press
	return_to_menu_requested.emit()
