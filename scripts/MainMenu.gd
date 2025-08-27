extends Control

## Main menu scene that handles game navigation and settings
## Provides entry point to the game and basic navigation

signal start_game_requested
signal quit_game_requested

@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $ChallengesButton  # Repurposed ChallengesButton as quit button

func _ready() -> void:
	# Connect button pressed signals with null checks
	if play_button:
		play_button.pressed.connect(_on_play_button_pressed)
		play_button.mouse_entered.connect(_on_play_button_hover)
	else:
		print("ERROR: PlayButton node not found in MainMenu scene")
	
	if quit_button:
		quit_button.pressed.connect(_on_quit_button_pressed)
		quit_button.mouse_entered.connect(_on_quit_button_hover)
	else:
		print("ERROR: ChallengesButton (quit button) node not found in MainMenu scene")
	
	print("Main menu ready - Welcome to My Booty!")
	if play_button:
		print("Play button position: ", play_button.position)
	if quit_button:
		print("Quit button position: ", quit_button.position)

## Button input handlers are now direct pressed() signal callbacks

func _on_play_button_pressed() -> void:
	## Handles play button press - starts the game
	print("Starting game...")
	start_game_requested.emit()


func _on_quit_button_pressed() -> void:
	## Handles quit button press
	print("Quitting game...")
	quit_game_requested.emit()


func _on_play_button_hover() -> void:
	print("Mouse entered play button")


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
