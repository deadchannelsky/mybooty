# AdMob Integration Setup Guide

This guide covers the complete setup for AdMob interstitial ads in your Godot 4.4 My Booty game.

## Implementation Overview

The AdMob integration adds interstitial ads that display when the user clicks the "Set Sail Again!" button after a game over. The user will see the ad, then the game will restart.

**✅ SETUP COMPLETE!** The official AdMob plugin has been installed and configured.

## Files Modified/Created

### New Files:
- `scripts/AdMobManager.gd` - Singleton for managing AdMob functionality
- `addons/admob/plugin.cfg` - AdMob plugin configuration
- `addons/admob/plugin.gd` - AdMob plugin script
- `android/build/AndroidManifest.xml` - Android manifest with AdMob configuration
- `scripts/AdMobTest.gd` - Testing script for AdMob functionality

### Modified Files:
- `project.godot` - Added AdMobManager autoload and plugin configuration
- `scripts/UI.gd` - Integrated interstitial ads with restart button
- `export_presets.cfg` - Updated Android export settings and permissions

## Required Setup Steps

### 1. Install AdMob Plugin (Recommended Method)
1. Open Godot Engine
2. Go to Project → Asset Library
3. Search for "AdMob" by "poing.studios"
4. Download and install the plugin
5. Enable the plugin in Project → Project Settings → Plugins

### 2. Download Platform Libraries
1. In Godot, go to Project → Tools → AdMob Download Manager
2. Select Android → Latest Version
3. Download the Android library files
4. Copy contents from `res://addons/admob/downloads/android/` to `res://android/plugins/`

### 3. Configure Your AdMob App ID
1. Get your AdMob App ID from Google AdMob console
2. Update `android/build/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="YOUR_ACTUAL_ADMOB_APP_ID" />
   ```

### 4. Set Production Ad Unit IDs
1. Open `scripts/AdMobManager.gd`
2. Update the production ad unit ID constants:
   ```gdscript
   const PROD_ANDROID_INTERSTITIAL_ID: String = "YOUR_ANDROID_INTERSTITIAL_ID"
   const PROD_IOS_INTERSTITIAL_ID: String = "YOUR_IOS_INTERSTITIAL_ID"
   ```
3. Set `USE_TEST_ADS = false` when ready for production

## Testing

### Development Testing (Test Ads)
The implementation uses test ad unit IDs by default:
- Android: `ca-app-pub-3940256099942544/1033173712`
- iOS: `ca-app-pub-3940256099942544/4411468910`

### Testing Flow:
1. Play the game until game over
2. Click "Set Sail Again!" button
3. If AdMob is properly configured:
   - Button text changes to "Loading Ad..."
   - Interstitial ad displays
   - After closing ad, game restarts
4. If AdMob is not available:
   - Game restarts directly without ad

### Testing Script:
Run `AdMobTest.gd` to validate AdMob manager functionality:
```gdscript
# Add this to any scene to test
var test_script = preload("res://scripts/AdMobTest.gd").new()
add_child(test_script)
```

## Build Configuration

### Android Export Settings:
- Internet permission: ✓ Enabled
- Access Network State permission: ✓ Enabled
- Package name: `com.example.mybooty`
- Target SDK: 34
- Architecture: arm64-v8a

### Required Gradle Build:
The AdMob plugin requires Gradle build to be enabled in export settings.

## Production Deployment

### Before Publishing:
1. Replace test App ID with your production AdMob App ID
2. Replace test ad unit IDs with your production interstitial ad unit IDs
3. Set `USE_TEST_ADS = false` in `AdMobManager.gd`
4. Test thoroughly with production IDs

### AdMob Console Setup:
1. Create app in Google AdMob console
2. Create interstitial ad unit
3. Note the App ID and Ad Unit ID for configuration
4. Set up payment and tax information

## Troubleshooting

### Common Issues:

1. **AdMobManager not available**:
   - Check that AdMobManager is in Project Settings → Autoload
   - Verify the script path is correct

2. **Ads not loading**:
   - Check internet connection
   - Verify App ID in AndroidManifest.xml
   - Check console for error messages

3. **Build errors**:
   - Ensure AdMob plugin is properly installed
   - Check Android SDK and build tools are updated
   - Verify all required permissions are enabled

### Console Output:
Monitor the console for AdMob-related messages:
- `AdMobManager: Mobile Ads SDK initialized`
- `AdMobManager: Loading interstitial ad...`
- `AdMobManager: Interstitial ad loaded successfully`
- `UI: Showing interstitial ad before restart`

## Integration Notes

The implementation follows these principles:
- Graceful degradation: If AdMob is unavailable, the game continues normally
- User experience: Clear feedback during ad loading
- Error handling: Proper cleanup if ads fail to load or show
- Pre-loading: Ads are loaded in advance for better user experience
- Single responsibility: AdMobManager handles all ad logic separately from UI

## Security Considerations

- Never commit production App IDs or Ad Unit IDs to public repositories
- Use test IDs during development to avoid policy violations
- Ensure proper user privacy compliance based on your region's requirements