extends Node2D

## Main scene controller that manages game state transitions
## Handles switching between menu, gameplay, and game over states

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.MAIN_MENU
var main_menu_scene: PackedScene = preload("res://scenes/MainMenu.tscn")
var game_scene: PackedScene = preload("res://scenes/Game.tscn")

var current_scene_instance: Node = null

func _ready() -> void:
	# Start with main menu
	show_main_menu()
	print("My Booty initialized - showing main menu")

func show_main_menu() -> void:
	## Shows the main menu scene
	current_state = GameState.MAIN_MENU
	_switch_to_scene(main_menu_scene)
	
	if current_scene_instance:
		current_scene_instance.start_game_requested.connect(_on_start_game_requested)
		current_scene_instance.quit_game_requested.connect(_on_quit_game_requested)

func start_game() -> void:
	## Starts the main game
	current_state = GameState.PLAYING
	_switch_to_scene(game_scene)
	
	if current_scene_instance:
		current_scene_instance.return_to_main_menu.connect(_on_return_to_main_menu)

func _switch_to_scene(scene: PackedScene) -> void:
	## Helper to switch between scenes
	if current_scene_instance:
		current_scene_instance.queue_free()
	
	current_scene_instance = scene.instantiate()
	add_child(current_scene_instance)

func _on_start_game_requested() -> void:
	## Handles start game request from main menu
	start_game()

func _on_quit_game_requested() -> void:
	## Handles quit request
	print("Thanks for playing My Booty! Goodbye!")
	get_tree().quit()

func _on_return_to_main_menu() -> void:
	## Handles return to menu request from game
	show_main_menu()

func _input(event: InputEvent) -> void:
	## Handle global input
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and current_state == GameState.PLAYING:
			_on_return_to_main_menu()