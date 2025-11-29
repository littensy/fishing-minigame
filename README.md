# fishing-minigame

https://github.com/user-attachments/assets/5431be51-7f33-4a60-81d3-1b33003134b0

A recreation of [Fisch](https://www.roblox.com/games/16732694052) using [reactive signals](https://github.com/littensy/charm/tree/alien-signals) for game state.

[Play the game →](https://www.roblox.com/games/93337472103359)

## Features

- Simulation is deterministic with a fixed-step solver
- Server resimulates player inputs to validate catches
- Game state is managed with [Charm](https://github.com/littensy/charm/tree/alien-signals)
- Declarative UI rendering with [Vide](https://centau.github.io/vide)

## Gameplay

1. With a fishing rod equipped, tap and hold to cast the rod. You can control the distance of your cast with the power meter.
2. Once the bobber touches water, you will begin luring fish. Tap the "Shake" button to attract fish faster.
3. While catching fish, keep the fish within the control bar by tapping and holding until the progress bar is complete.

---

<div align="center">

[![MIT License](https://img.shields.io/github/license/littensy/fishing-minigame?style=for-the-badge)](LICENSE)

</div>
