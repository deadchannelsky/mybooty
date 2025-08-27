extends CanvasLayer

## UI manager that handles all user interface elements
## Displays score, game state indicators, and menu screens

@onready var score_label: Label = get_node_or_null("ScoreLabel")
@onready var next_loot_sprite: Sprite2D = get_node_or_null("NextLootContainer/NextLootSprite")
@onready var pause_button: Button = get_node_or_null("PauseButton")
@onready var warning_label: Label = get_node_or_null("WarningLabel")
@onready var game_over_container: Control = get_node_or_null("GameOverContainer")
@onready var reason_label: Label = get_node_or_null("GameOverContainer/GameOverPanel/GameOverVBox/ReasonLabel")
@onready var final_score_label: Label = get_node_or_null("GameOverContainer/GameOverPanel/GameOverVBox/FinalScoreLabel")
@onready var restart_button: Button = get_node_or_null("GameOverContainer/GameOverPanel/GameOverVBox/RestartButton")
@onready var menu_button: Button = get_node_or_null("GameOverContainer/GameOverPanel/GameOverVBox/MenuButton")
@onready var pause_overlay: Control = get_node_or_null("PauseOverlay")
@onready var continue_button: Button = get_node_or_null("PauseOverlay/PausePanel/PauseVBox/ContinueButton")
@onready var quit_to_menu_button: Button = get_node_or_null("PauseOverlay/PausePanel/PauseVBox/QuitToMenuButton")

signal pause_game_requested
signal restart_game_requested
signal return_to_menu_requested
signal continue_game_requested
signal quit_to_menu_from_pause_requested

# Ad integration state
var _waiting_for_ad_to_close: bool = false

# Loot sprite texture and regions
var loot_texture: Texture2D = preload("res://art/loot_sprites.png")
var loot_sprite_regions: Dictionary = {
	"barrel": Rect2(528, 284, 170, 207),
	"cannonball": Rect2(291, 284, 183, 178),
	"treasure_chest": Rect2(735, 276, 257, 201),
	"bottle": Rect2(530, 29, 154, 246),
	"sword": Rect2(23, 24, 222, 238),
	"hook": Rect2(528, 33, 164, 240),
	"skull": Rect2(755, 491, 178, 196),
	"cup": Rect2(314.79, 489.493, 158.626, 214.359),
	"idol": Rect2(38.2666, 673.841, 192.923, 214.359),
	"crown": Rect2(276, 707, 213, 145),
	"hat": Rect2(466.672, 775.82, 287.241, 186.492),
	"spyglass": Rect2(193.55, 858.433, 255.087, 143.62),
	"pegleg": Rect2(764.92, 853.757, 184.349, 152.195),
	"map": Rect2(728.502, 690.99, 259.374, 171.487)
	}

func _ready() -> void:
	# Initialize UI elements
	update_score(0)
	
	# Connect button signals with null checks
	if pause_button:
		pause_button.pressed.connect(_on_pause_button_pressed)
		print("UI: Connected pause button signal")
	else:
		print("ERROR: PauseButton node not found in UI scene")
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
		print("UI: Connected restart button signal")
	else:
		print("ERROR: RestartButton node not found in UI scene")
	
	if menu_button:
		menu_button.pressed.connect(_on_menu_button_pressed)
		print("UI: Connected menu button signal")
	else:
		print("ERROR: MenuButton node not found in UI scene")
	
	# Connect pause overlay button signals
	if continue_button:
		continue_button.pressed.connect(_on_continue_button_pressed)
		print("UI: Connected continue button signal")
	else:
		print("ERROR: ContinueButton node not found in UI scene")
	
	if quit_to_menu_button:
		quit_to_menu_button.pressed.connect(_on_quit_to_menu_button_pressed)
		print("UI: Connected quit to menu button signal")
	else:
		print("ERROR: QuitToMenuButton node not found in UI scene")
	
	# Connect to AdMob manager signals
	if AdMobManager:
		AdMobManager.interstitial_ad_closed.connect(_on_interstitial_ad_closed)
		print("UI: Connected to AdMobManager signals")

func update_score(new_score: int) -> void:
	## Updates the score display with the current score value
	if score_label:
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
	if reason_label:
		reason_label.text = reason
	if final_score_label:
		final_score_label.text = "Final Score: " + str(final_score)
	if game_over_container:
		game_over_container.visible = true
	if restart_button:
		restart_button.grab_focus()
	
	print("\n=== GAME OVER ===")
	print("Reason: ", reason)
	print("Final Score: ", final_score)
	print("================\n")

func hide_game_over_screen() -> void:
	## Hides the game over screen
	if game_over_container:
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
	## Handles restart button press - shows interstitial ad first
	print("UI: Restart button pressed")
	
	if not AdMobManager:
		print("UI: AdMobManager not available, restarting game directly")
		restart_game_requested.emit()
		return
	
	# Debug: Check ad manager state
	print("UI: AdMobManager available, checking ad readiness...")
	print("UI: AdMob plugin available: ", AdMobManager._admob_plugin != null)
	
	# Try to show interstitial ad before restarting
	if AdMobManager.is_interstitial_ready():
		print("UI: ✓ Interstitial ad is ready - showing ad before restart")
		_waiting_for_ad_to_close = true
		# Disable the button temporarily to prevent multiple clicks
		if restart_button:
			restart_button.disabled = true
			restart_button.text = "🔄 Loading Ad..."
		
		# Show the ad
		var ad_shown: bool = AdMobManager.show_interstitial_ad()
		if not ad_shown:
			print("UI: Failed to show ad, restarting directly")
			_reset_restart_button()
			restart_game_requested.emit()
	else:
		print("UI: ⚠ No interstitial ad ready - checking why...")
		if AdMobManager._admob_plugin:
			print("UI: Plugin exists, loading new ad and restarting directly")
			AdMobManager.load_interstitial_ad()
		else:
			print("UI: Plugin not available")
		restart_game_requested.emit()

func _on_interstitial_ad_closed() -> void:
	## Called when interstitial ad is closed - now restart the game
	if _waiting_for_ad_to_close:
		print("UI: Interstitial ad closed, restarting game now")
		_waiting_for_ad_to_close = false
		_reset_restart_button()
		restart_game_requested.emit()

func _reset_restart_button() -> void:
	## Reset the restart button to its original state
	if restart_button:
		restart_button.disabled = false
		restart_button.text = "🔄 Set Sail Again! (R)"

func _on_menu_button_pressed() -> void:
	## Handles return to menu button press
	return_to_menu_requested.emit()

func show_pause_overlay() -> void:
	## Shows the pause overlay with continue and quit options
	if pause_overlay:
		pause_overlay.visible = true
		# Focus the continue button for better UX
		if continue_button:
			continue_button.grab_focus()
		print("UI: Showing pause overlay")
	else:
		print("ERROR: PauseOverlay node not found")

func hide_pause_overlay() -> void:
	## Hides the pause overlay
	if pause_overlay:
		pause_overlay.visible = false
		print("UI: Hiding pause overlay")
	else:
		print("ERROR: PauseOverlay node not found")

func _on_continue_button_pressed() -> void:
	## Handles continue button press from pause overlay
	print("UI: Continue button pressed")
	continue_game_requested.emit()

func _on_quit_to_menu_button_pressed() -> void:
	## Handles quit to menu button press from pause overlay
	print("UI: Quit to menu button pressed from pause overlay")
	quit_to_menu_from_pause_requested.emit()
