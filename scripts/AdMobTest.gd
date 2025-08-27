extends Node

## AdMob Integration Test Script
## This script validates the complete AdMob setup with the official plugin
## Run this script to test AdMob manager functionality

func _ready() -> void:
	print("\n=== AdMob Integration Test (Official Plugin) ===")
	
	# Test AdMob Manager singleton availability
	if AdMobManager:
		print("✓ AdMobManager singleton is available")
		test_admob_manager()
	else:
		print("✗ AdMobManager singleton is NOT available")
		print("  Make sure AdMobManager is added to autoload in project settings")
	
	# Test restart flow simulation
	test_restart_flow()
	
	print("=== Test Complete ===\n")

func test_admob_manager() -> void:
	## Test AdMobManager functionality with official plugin
	
	# Test plugin availability
	if AdMobManager._admob_plugin:
		print("✓ Official AdMob plugin is initialized")
	else:
		print("✗ Official AdMob plugin is NOT initialized")
		print("  Check that AdMob plugin is enabled in project settings")
	
	# Test interstitial ad readiness
	var is_ready: bool = AdMobManager.is_interstitial_ready()
	print("AdMob interstitial ready: ", is_ready)
	
	# Connect to AdMob signals for testing
	if not AdMobManager.interstitial_ad_loaded.is_connected(_on_test_ad_loaded):
		AdMobManager.interstitial_ad_loaded.connect(_on_test_ad_loaded)
	if not AdMobManager.interstitial_ad_failed_to_load.is_connected(_on_test_ad_failed):
		AdMobManager.interstitial_ad_failed_to_load.connect(_on_test_ad_failed)
	if not AdMobManager.interstitial_ad_closed.is_connected(_on_test_ad_closed):
		AdMobManager.interstitial_ad_closed.connect(_on_test_ad_closed)
	if not AdMobManager.interstitial_ad_showed.is_connected(_on_test_ad_showed):
		AdMobManager.interstitial_ad_showed.connect(_on_test_ad_showed)
	
	print("✓ Connected to AdMob manager test signals")
	
	# Display configuration info
	print("Using test ads: ", AdMobManager.USE_TEST_ADS)
	print("Android test ID: ", AdMobManager.TEST_ANDROID_INTERSTITIAL_ID)
	print("iOS test ID: ", AdMobManager.TEST_IOS_INTERSTITIAL_ID)
	
	# Test will automatically try to load ad on initialization

func _on_test_ad_loaded() -> void:
	print("✓ Test: Interstitial ad loaded successfully")

func _on_test_ad_failed(error_message: String) -> void:
	print("⚠ Test: Interstitial ad failed to load: ", error_message)
	print("  This is normal in desktop testing - ads only work on mobile devices")

func _on_test_ad_closed() -> void:
	print("✓ Test: Interstitial ad closed successfully")

func _on_test_ad_showed() -> void:
	print("✓ Test: Interstitial ad showed successfully")

# Test function to simulate the complete restart flow
func test_restart_flow() -> void:
	print("\n=== Testing Complete Restart Flow ===")
	print("1. Game Over triggered")
	print("2. User clicks 'Set Sail Again!' button")
	print("3. UI.gd calls _on_restart_button_pressed()")
	print("4. UI checks if AdMobManager is available...")
	
	if AdMobManager:
		print("5. ✓ AdMobManager is available")
		print("6. UI checks if interstitial ad is ready...")
		
		if AdMobManager.is_interstitial_ready():
			print("7. ✓ Interstitial ad is ready")
			print("8. UI shows 'Loading Ad...' and calls AdMobManager.show_interstitial_ad()")
			print("9. Ad displays (on mobile device)")
			print("10. When ad closes, _on_interstitial_ad_closed signal is emitted")
			print("11. UI resets button and emits restart_game_requested signal")
		else:
			print("7. ⚠ No interstitial ad ready")
			print("8. UI proceeds directly with restart_game_requested signal")
	else:
		print("5. ✗ AdMobManager not available - game restarts directly")
	
	print("=== Restart Flow Test Complete ===\n")

# Manual test function you can call from debug console
func test_ad_manually() -> void:
	print("=== Manual Ad Test ===")
	if AdMobManager and AdMobManager.is_interstitial_ready():
		print("Attempting to show test ad...")
		AdMobManager.show_interstitial_ad()
	else:
		print("No ad ready for manual test")
		if AdMobManager:
			print("Loading new ad...")
			AdMobManager.load_interstitial_ad()