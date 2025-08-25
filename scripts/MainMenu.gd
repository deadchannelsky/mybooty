extends Control

## Main menu scene that handles game navigation and settings
## Provides entry point to the game and basic navigation

signal start_game_requested
signal quit_game_requested

@onready var play_button: Button = $PlayButton
@onready var how_to_play_button: Button = $ChallengesButton
@onready var quit_button: Button = $LeaderboardsButton

func _ready() -> void:
	# Connect button pressed signals
	play_button.pressed.connect(_on_play_button_pressed)
	how_to_play_button.pressed.connect(_on_how_to_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Connect mouse entered for debugging
	play_button.mouse_entered.connect(_on_play_button_hover)
	how_to_play_button.mouse_entered.connect(_on_how_to_play_button_hover)
	quit_button.mouse_entered.connect(_on_quit_button_hover)
	
	print("Main menu ready - Welcome to My Booty!")
	print("Play button position: ", play_button.position)
	print("Challenges button position: ", how_to_play_button.position)
	print("Quit button position: ", quit_button.position)

## Button input handlers are now direct pressed() signal callbacks

func _on_play_button_pressed() -> void:
	## Handles play button press - starts the game
	print("Starting game...")
	start_game_requested.emit()

func _on_how_to_play_button_pressed() -> void:
	## Shows how to play instructions
	show_instructions()

func _on_quit_button_pressed() -> void:
	## Handles quit button press
	print("Quitting game...")
	quit_game_requested.emit()

func show_instructions() -> void:
	## Displays game instructions in a simple popup
	var instruction_text = """
	HOW TO PLAY MY BOOTY:
	
	🏴‍☠️ TAP anywhere to drop loot onto your ship
	📦 Stack loot carefully - don't let it fall overboard!
	⚖️ Keep your ship balanced - if it tips too far, you lose
	💰 Each loot type has different point values
	🎯 Try to beat your high score!
	
	GAME OVER when:
	- Ship tips over (>25°)
	- Too many items fall off (3+)
	- All loot is lost at sea
	
	Press R to restart anytime
	Press ESC to return to menu
	
	Good luck, Captain! ⚓
	"""
	
	print(instruction_text)
	# TODO: Create proper instruction popup in Phase 2

func _on_play_button_hover() -> void:
	print("Mouse entered play button")

func _on_how_to_play_button_hover() -> void:
	print("Mouse entered how to play button")

func _on_quit_button_hover() -> void:
	print("Mouse entered quit button")

func _input(event: InputEvent) -> void:
	## Handle escape key to quit and debug input
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked at: ", event.position)
	elif event is InputEventScreenTouch and event.pressed:
		print("Screen touched at: ", event.position)
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_on_quit_button_pressed()
