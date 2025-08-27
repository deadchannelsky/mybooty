# Phase 1 Development Tasks - Core Prototype

## Project Setup & Foundation
- [x] Create new Godot project with proper structure
- [x] Set up main scene hierarchy (Main → Game → UI)
- [x] Configure project settings (resolution, orientation: portrait)
- [x] Create basic folder structure (scenes/, scripts/, assets/, art/)


## Core Physics System
- [ ] Create RigidBody2D system for loot items
- [ ] Implement collision detection between loot pieces
- [ ] Set up physics world with appropriate gravity
- [ ] Create StaticBody2D for ship deck platform
- [ ] Test basic object dropping and stacking physics

## Ship Deck & Environment
- [ ] Create ship deck scene with basic platform ship decks are in ./art/decks_sprites.png
- [ ] Implement simple ship rocking motion (sin wave rotation)
- [ ] Add basic ocean background (simple blue gradient)
- [ ] Position ship deck select from decks sprites appropriately in scene
- [ ] Test rocking motion doesn't interfere with physics

## Loot System
- [ ] Create base Loot class/script for all items
- [ ] Implement  basic loot types for all loot sprites in ./art/lootsprites:
  - [ ] Barrel (medium size, stable)
  - [ ] Cannonball (small, heavy, rolls)
  - [ ] Treasure Chest (large, rectangular)
  - [ ] Bottle (tall, narrow, tips easily)
  - [ ] Sword (long, awkward shape)
  - [ ] Hook
  - [ ] Bottle
  - [ ] Fish
  - [x] Cup
  - [x] Skull  
  - [x] Idol
  - [x] Crown
  - [x] Hat
  - [x] Spyglass
  - [x] Pegleg
  - [x] Map

- [ ] Create loot spawner system (random selection)
- [ ] Add basic sprites/placeholder art for each loot type

## Input System
- [ ] Implement tap-to-drop mechanic
- [ ] Create loot preview system (shows next item to drop)
- [ ] Add drop position control (tap location affects drop point)
- [ ] Test input responsiveness on mobile

## Scoring System
- [ ] Create score manager script
- [ ] Award points for each successfully placed loot item
- [ ] Display current score in UI
- [ ] Track and display high score
- [ ] Save/load high score data

## Game Over Detection
- [ ] Detect when loot falls off ship deck
- [ ] Implement ship tipping threshold (angle limit)
- [ ] Create game over state management
- [ ] Show game over screen with final score
- [ ] Add restart functionality

## Basic UI
- [ ] Create main menu scene (Play button, title)
- [ ] Design game UI (score display, pause option)
- [ ] Implement game over screen (score, restart, menu)
- [ ] Add basic navigation between screens
- [ ] Style UI with pirate theme (wooden buttons, etc.)

## Testing & Polish
- [ ] Test core game loop (play → game over → restart)
- [ ] Balance loot physics properties
- [ ] Adjust ship rocking speed/amplitude
- [ ] Fine-tune scoring values
- [ ] Test on mobile device if possible
- [ ] Fix any critical bugs or crashes

## Documentation
- [ ] Comment all code for clarity
- [ ] Update this todo list with completion status
- [ ] Document any design decisions or changes
- [ ] Prepare notes for Phase 2 planning

---

## Success Criteria for Phase 1 Completion:
✅ Player can start game from main menu  
✅ Loot drops and stacks realistically on ship deck  
✅ Ship rocks gently without breaking physics  
✅ Game ends when stack falls or ship tips too far  
✅ Score is tracked and displayed  
✅ Player can restart immediately after game over  
✅ All 5 loot types have unique physics properties  
✅ Game is stable and playable for 2+ minutes  

---

# Android Build Environment Setup - Completed

## ✅ Completed Tasks

### 1. Install Java Development Kit (JDK) 17
- [x] Installed OpenJDK 17 via Homebrew
- [x] Set up JAVA_HOME and PATH environment variables  
- [x] Verified Java 17 installation

### 2. Install Android Studio with SDK and tools
- [x] Installed Android Studio via Homebrew
- [x] Set up ANDROID_HOME environment variables

### 3. Generate Debug Keystore
- [x] Created debug keystore at `~/.android/debug.keystore`
- [x] Configured with standard Android debug credentials

### 4. Configure Export Settings
- [x] Updated export_presets.cfg with proper package name
- [x] Enabled custom build (use_gradle_build=true)
- [x] Added debug keystore configuration
- [x] Set version name and package details

## 📋 Manual Steps Required

### Install Android Build Template in Godot
**You need to complete this step manually:**
1. Open your project in Godot
2. Go to `Project` → `Install Android Build Template...`
3. Click "Manage Templates..."
4. Click "Download" for your current Godot version
5. Click "Install" in the confirmation dialog

### Complete Android SDK Setup
1. Launch Android Studio first time to complete SDK installation
2. Accept all SDK licenses
3. Install recommended SDK components

## 🎯 Ready for Testing

Once you complete the manual steps above, you can:

1. Open your project in Godot
2. Go to `Project` → `Export...`
3. Select the "Android" preset
4. Click "Export Project"
5. Choose a filename ending in .apk
6. Click "Save" to build the APK

## 🔧 Environment Configuration Summary

- **Java**: OpenJDK 17 installed and configured
- **Android Studio**: Installed with SDK tools
- **Debug Keystore**: Created at `~/.android/debug.keystore`
- **Package Name**: `com.campfirenerds.mybooty`
- **Architecture**: ARM64 (arm64-v8a) - suitable for modern Android devices
- **Signing**: Configured for debug builds

## Review

Successfully prepared the development environment for Android builds:
- Installed all required development tools (Java 17, Android Studio)
- Generated debug keystore for app signing  
- Configured Godot export settings with proper package information
- Set up environment variables for SDK access

The setup follows Godot's official requirements and uses industry-standard tools. Manual completion of Android Build Template installation in Godot will enable APK export functionality.

---

## Notes:
- Focus on making the core loop fun before adding complexity
- Keep art simple/placeholder for Phase 1 - gameplay first
- Test frequently on actual mobile device
- Each loot type should feel different when dropped
- Ship rocking should add challenge but not frustration