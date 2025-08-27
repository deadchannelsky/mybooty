extends Node

## AdMob Manager Singleton
## Handles all interstitial ad loading, showing, and callback management
## Use this singleton to display ads throughout the game

# AdMob plugin reference
var _admob_plugin: Admob
var _is_ad_loaded: bool = false

# Test Ad Unit IDs (replace with your production IDs)
const TEST_ANDROID_INTERSTITIAL_ID: String = "ca-app-pub-3940256099942544/1033173712"
const TEST_IOS_INTERSTITIAL_ID: String = "ca-app-pub-3940256099942544/4411468910"

# Production Ad Unit IDs (set these to your actual AdMob unit IDs)
const PROD_ANDROID_INTERSTITIAL_ID: String = "YOUR_ANDROID_INTERSTITIAL_ID"
const PROD_IOS_INTERSTITIAL_ID: String = "YOUR_IOS_INTERSTITIAL_ID"

# Use test ads during development
const USE_TEST_ADS: bool = true

# Callback signals for ad events
signal interstitial_ad_loaded
signal interstitial_ad_failed_to_load(error_message: String)
signal interstitial_ad_closed
signal interstitial_ad_showed

func _ready() -> void:
	## Initialize AdMob plugin when singleton is loaded
	
	# Create AdMob plugin instance
	_admob_plugin = Admob.new()
	add_child(_admob_plugin)
	
	if _admob_plugin:
		print("AdMobManager: AdMob plugin initialized")
		
		# Configure the plugin with test/production settings
		_configure_plugin()
		
		# Set up callbacks
		_setup_callbacks()
		
		# Initialize the plugin
		_admob_plugin.initialize()
		
		# Pre-load the first interstitial ad after a short delay
		get_tree().create_timer(2.0).timeout.connect(_on_timer_load_ad)
	else:
		print("AdMobManager: AdMob plugin not available")

func _configure_plugin() -> void:
	## Configure the AdMob plugin with appropriate test/production IDs
	
	if USE_TEST_ADS:
		_admob_plugin.is_real = false
		_admob_plugin.debug_interstitial_id = TEST_ANDROID_INTERSTITIAL_ID
		print("AdMobManager: Configured for test ads with ID: ", TEST_ANDROID_INTERSTITIAL_ID)
	else:
		_admob_plugin.is_real = true
		var platform: String = OS.get_name()
		if platform == "Android":
			_admob_plugin.real_interstitial_id = PROD_ANDROID_INTERSTITIAL_ID
		elif platform == "iOS":
			_admob_plugin.real_interstitial_id = PROD_IOS_INTERSTITIAL_ID
		print("AdMobManager: Configured for production ads")

func _setup_callbacks() -> void:
	## Set up all ad callback handlers for the official AdMob plugin
	
	# Connect interstitial ad signals
	_admob_plugin.interstitial_ad_loaded.connect(_on_interstitial_loaded)
	_admob_plugin.interstitial_ad_failed_to_load.connect(_on_interstitial_failed_to_load)
	_admob_plugin.interstitial_ad_clicked.connect(_on_ad_clicked)
	_admob_plugin.interstitial_ad_dismissed_full_screen_content.connect(_on_ad_dismissed)
	_admob_plugin.interstitial_ad_failed_to_show_full_screen_content.connect(_on_ad_failed_to_show)
	_admob_plugin.interstitial_ad_impression.connect(_on_ad_impression)
	_admob_plugin.interstitial_ad_showed_full_screen_content.connect(_on_ad_showed)
	_admob_plugin.initialization_completed.connect(_on_initialization_completed)
	
	print("AdMobManager: Callbacks connected to official AdMob plugin")

func load_interstitial_ad() -> void:
	## Load an interstitial ad for later display
	
	_is_ad_loaded = false
	
	if not _admob_plugin:
		print("AdMobManager: AdMob plugin not available, cannot load ad")
		return
	
	print("AdMobManager: Loading interstitial ad using configured unit IDs")
	
	# Load the interstitial ad using the official plugin
	# The plugin uses its own configured ad unit IDs
	_admob_plugin.load_interstitial_ad()

func show_interstitial_ad() -> bool:
	## Show the interstitial ad if it's loaded
	## Returns true if ad was shown, false if not available
	
	if not _admob_plugin:
		print("AdMobManager: AdMob plugin not available, cannot show ad")
		return false
	
	print("AdMobManager: Showing interstitial ad")
	# Show interstitial ad - plugin will use first available loaded ad
	_admob_plugin.show_interstitial_ad()
	return true

func is_interstitial_ready() -> bool:
	## Check if an interstitial ad is ready to show
	## Uses the plugin's actual ad loading state instead of local flag
	if _admob_plugin == null:
		return false
	return _admob_plugin.is_interstitial_ad_loaded()

# Timer callback for loading ads
func _on_timer_load_ad() -> void:
	## Timer callback to load interstitial ad
	load_interstitial_ad()

# Removed _get_interstitial_unit_id() - plugin handles unit IDs internally

# Callback handlers for official AdMob plugin
func _on_initialization_completed(status_data: InitializationStatus) -> void:
	## Called when AdMob SDK initialization completes
	print("AdMobManager: AdMob SDK initialization completed")

func _on_interstitial_loaded(ad_id: String) -> void:
	## Called when interstitial ad successfully loads
	print("AdMobManager: Interstitial ad loaded successfully for ID: ", ad_id)
	_is_ad_loaded = true
	interstitial_ad_loaded.emit()

func _on_interstitial_failed_to_load(ad_id: String, error_data: LoadAdError) -> void:
	## Called when interstitial ad fails to load
	print("AdMobManager: Failed to load interstitial ad for ID ", ad_id, ": ", error_data.message)
	_is_ad_loaded = false
	interstitial_ad_failed_to_load.emit(error_data.message)

func _on_ad_clicked(ad_id: String) -> void:
	## Called when user clicks the ad
	print("AdMobManager: Interstitial ad clicked for ID: ", ad_id)

func _on_ad_dismissed(ad_id: String) -> void:
	## Called when user dismisses the ad
	print("AdMobManager: Interstitial ad dismissed for ID: ", ad_id)
	
	# Reset ad loaded state
	_is_ad_loaded = false
	
	# Signal that ad is closed (UI can now proceed with restart)
	interstitial_ad_closed.emit()
	
	# Pre-load next ad for future use
	get_tree().create_timer(1.0).timeout.connect(_on_timer_load_ad)

func _on_ad_failed_to_show(ad_id: String, error_data: AdError) -> void:
	## Called when ad fails to show
	print("AdMobManager: Failed to show interstitial ad for ID ", ad_id, ": ", error_data.message)
	
	# Reset ad loaded state
	_is_ad_loaded = false
	
	# Signal that ad process is complete (even though it failed)
	interstitial_ad_closed.emit()

func _on_ad_impression(ad_id: String) -> void:
	## Called when ad impression is recorded
	print("AdMobManager: Interstitial ad impression recorded for ID: ", ad_id)

func _on_ad_showed(ad_id: String) -> void:
	## Called when ad is successfully displayed
	print("AdMobManager: Interstitial ad showed successfully for ID: ", ad_id)
	interstitial_ad_showed.emit()
