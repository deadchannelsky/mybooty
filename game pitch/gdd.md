This is the game design document. This is the guiding document for the game development. 

---

# 🏴‍☠️ *Pirate Booty* — Game Design Document (GDD)

---

## 🎮 Game Overview

**Title**: My Booty
**Genre**: Casual / Physics Stacking / Arcade
**Platform**: Mobile (iOS & Android, portrait orientation)
**Target Audience**: Casual players ages 8–40, fans of light puzzle/arcade challenges, pirate theme enthusiasts.
**Session Length**: 30 seconds – 2 minutes.
**Monetization**: Premium (\$0.99 – \$1.50 base price) + optional cosmetic unlocks.

---

## ⚓ Core Gameplay

**Core Loop**

1. Drop loot onto rocking pirate ship deck.
2. Balance growing stack against physics and random chaos events.
3. Earn points for each item stacked; bonus for risky placements and rare loot.
4. When ship tips or too much loot falls → *Game Over*.
5. Player retries immediately or explores challenges/unlocks.

**Controls**

* **Tap**: Drop item.
* **Swipe (optional)**: Adjust drop position slightly.

**Difficulty Curve**

* Ship tilt affected by item weight with pile height.
* Storm waves and random events trigger after thresholds.
* Heavier, oddly shaped loot introduced gradually.

---

## ✨ Features

* **Loot Variety**: Barrels, cannons, swords, parrots, bottles, treasure chests, cursed skulls.
* **Random Events**: Seagull dive, monkey push, sudden storm gust.
* **Progression**:

  * Unlock ships (dinghy → brigantine → galleon).
  * Unlock cosmetic skins for loot and ships.
* **Challenges Mode**: Daily/weekly modifiers (e.g., “Storm Seas,” “Monkey Madness”).
* **Leaderboards**: Local + global high score tracking.

---

## 🎨 Art Direction

* **Style**: Bold cartoon aesthetic with exaggerated pirate flair.
* **UI**: Wooden sign buttons, parchment popups, pirate font.
* **Environment**: Ocean horizon backgrounds (day, sunset, storm).
* **Characters/Items**: Anthropomorphic parrots, cheeky monkeys, loot with personality.

---

## 🔊 Audio Direction

* **Music**: Upbeat pirate shanty loops with tempo that escalates as stack grows.
* **SFX**:

  * *Loot*: Cannonball thuds, gold coin clinks, bottle glass rattles.
  * *Ship*: Wooden creaks, rope tension sounds, ocean waves.
  * *Events*: Seagull squawk, monkey chatter, thunder rumbles.
* **Game Over**: Humorous pirate quips voiced or text-based.

---

## ⚙️ Technical Design

* **Engine**: Godot.
* **Core Systems**:

  * Physics (stacking, tipping).
  * Loot randomizer + procedural spawning.
  * Difficulty escalation (wave force + random events).
  * Leaderboard integration.
* **Assets Needed**:

  * 20–30 loot sprites.
  * 3–5 ship deck backgrounds.
  * UI kit (wooden buttons, parchment).
  * Simple particle effects (coin sparkle, wood splinters).

---

## 💰 Monetization

* **Base Purchase**: \$0.99 – \$1.50 (one-time, no ads).
* **Optional Cosmetic DLC**:

  * Themed loot packs (Halloween pumpkins, Christmas presents, Steampunk gadgets).
  * Alternate ship decks and backgrounds.
* **Retention Hook**: Daily challenge rewards → cosmetic unlocks.

---

## 📅 Development Milestones

* **Prototype (2–3 weeks)**:

  * Core physics loop, basic loot shapes, single ship background.
* **Alpha (6–8 weeks)**:

  * Loot variety, difficulty scaling, basic UI, placeholder art.
* **Beta (10–12 weeks)**:

  * Final art pass, audio, challenges mode, leaderboards.
* **Release Candidate (12–14 weeks)**:

  * Bug fixing, polish, cosmetic packs, store submission.

---

## 🎯 Unique Selling Points

* Pirate theme (universally appealing, underutilized in stacking genre).
* High replayability (unpredictable physics chaos).
* Small-studio friendly scope (low content burden, relies on physics + polish).
* Clear monetization path via cosmetic unlocks.

---

⚓ **Tagline**: *“Stack the loot, don’t sink the ship!”*

---

Would you like me to **expand this into a 3–4 page “investor-style” deck** with mockup screens, art direction palette, and monetization forecasts (charts & comparisons to similar titles)? That would make it pitch-ready for a publisher or funding round.
