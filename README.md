# SohdRunner

**Game Name:** SohdRunner  
**Developer / Credits:** Ahmed  
**Version:** 1.0.0  
**Platform:** Android (standalone offline APK)  
**Primary Game Language:** Lua (Lua 5.2 via LuaJ with a native 3D Android bridge)  
**Distribution Targets:** Uptodown & itch.io  

Public source repository: https://github.com/ahamdmurad02-dev/SohdRunner

---

## Short description

Sprint through clean low-poly 3D city streets as a determined businessman. Dodge road barriers, leap over cargo crates, and collect spinning gold coins in a lightweight, offline 3D endless runner powered by Lua.

---

## Full description

**SohdRunner** is a fast-paced, lightweight 3D endless runner built in **Lua** for Android, without a heavy third-party game engine.

Take control of a blocky, low-poly businessman on a morning sprint through an endless 3D city avenue. As speed increases, time jumps over red-and-white road barriers, wooden crates, and concrete dividers while weaving between lanes to collect gold coins.

### Key features
- **Manual 3D architecture (no game engine):** custom 3D perspective projection, near-plane frustum clipping, backface culling, directional daylight shading, and painter's depth sorting.
- **Lua-driven gameplay:** physics, 3D collisions, player state, camera, procedural levels, obstacle pooling, and game states live in `app/src/main/assets/lua/`.
- **Offline and lightweight:** no accounts or servers. High scores and lifetime stats are saved on-device.

---

## Controls

| Gesture / input | Action |
| :--- | :--- |
| Swipe left | Move one lane left |
| Swipe right | Move one lane right |
| Swipe up | Jump over low barriers, boxes, and walls |
| Swipe down | Fast-fall while airborne |
| Pause / system back | Pause or resume |

---

## Build from source

This repository contains the Android Studio / Gradle source. Binary APKs are not committed.

Requirements:
- Android Studio (or JDK 17+ and Android SDK)
- Android SDK with compile/target API 36
- Minimum device: Android 7.0 (API 24)

Open the project root in Android Studio and run the `app` configuration, or:

```bash
./gradlew :app:assembleDebug
```

Note: `gradle-wrapper.jar` is not included here. Generate the wrapper locally with a installed Gradle, or open the project in Android Studio so it can create the wrapper.

See [`UPTODOWN_RELEASE_GUIDE.md`](./UPTODOWN_RELEASE_GUIDE.md) for store listing text and package metadata.

---

## Technical information

- **Application ID:** `com.aistudio.sohdrunner.ahmdrx`
- **Version name:** `1.0.0` (`versionCode = 1`)
- **Minimum SDK:** API 24 (Android 7.0+)
- **Target / compile SDK:** API 36

### Lua modules (`app/src/main/assets/lua/`)
- `physics.lua` — gravity, jump, fast-fall, lane interpolation, speed, frame-rate-independent integration
- `collision.lua` — 3D AABB / sphere tests, ground height, road bounds
- `player.lua` — low-poly businessman mesh and lane/jump controller
- `camera.lua` — third-person follow camera
- `world.lua` — endless 3-lane city road and scenery
- `level_generator.lua` — procedural waves and difficulty scaling
- `obstacles.lua` — pooled 3D obstacles
- `coins.lua` — pooled coins and collection particles
- `ui_state.lua` — `MENU`, `PLAYING`, `PAUSED`, `GAME_OVER`
- `audio.lua` — sound and music state
- `save_system.lua` — local high score and coins
- `input.lua` — swipe input with jump buffering
- `game.lua` — main Lua coordinator

### Android native bridge (`app/src/main/java/com/example/`)
- `lua/LuaGameBridge.kt` — embedded LuaJ VM and asset module loader
- `rendering/SohdRenderer3D.kt` & `SceneBuffer.kt` — 3D renderer
- `audio/SohdAudioEngine.kt` — synthesized PCM SFX and music loop
- `data/RunDatabase.kt` — local Room / SharedPreferences storage

---

## Credits

**SohdRunner**  
**Developed by Ahmed**

---

## License

Copyright © 2026 Ahmed. All rights reserved.
