# roblox-upside-engine-starter

A barebones starter project for using Upside Engine to do 2D game development in Roblox.

## Getting Started

1. **Install the Upside Engine package**
   - In Roblox Studio, open the Toolbox and search for "Upside Engine".
   - Insert the package into your experience; it should appear under `ReplicatedStorage/UpsideEngine` by default.

2. **Locate the entry point**
   - The client bootstrap script lives at `StarterPlayer/StarterPlayerScripts/ClientStarterScript.lua` and requires your top-level scene module to start the game.
   - Shared game code should be implemented as `ModuleScripts` placed in `ReplicatedStorage` so both client and server can require them.

3. **Add sprites and scenes**
   - Create new scene modules under `ReplicatedStorage/Scenes` following the existing module patterns.
   - Add sprite definitions or assets under `ReplicatedStorage/Assets`. Reference Roblox assets using their asset IDs when loading images or sounds.

4. **Run the game**
   - Press **Play** in Roblox Studio; the client bootstrap in `StarterPlayerScripts` will require your scene module and start the Upside Engine loop.
   - For multiplayer testing, use **Start** to launch multiple clients; shared code in `ModuleScripts` ensures consistent behavior across clients.

## Roblox conventions

- Place reusable/shared code in `ModuleScripts` (typically under `ReplicatedStorage`) so it can be required from both client and server scripts.
- Client entry scripts belong in `StarterPlayerScripts` so they run automatically when a player joins.
- Reference assets (images, sounds, fonts) by their Roblox asset IDs when loading them in your scripts.

## Project structure

- `ReplicatedStorage/UpsideEngine`: Upside Engine package inserted from Toolbox.
- `ReplicatedStorage/Assets`: Example assets (add your own with Roblox asset IDs).
- `ReplicatedStorage/Scenes`: Scene modules that define your gameplay logic.
- `StarterPlayer/StarterPlayerScripts/ClientStarterScript.lua`: Client bootstrap that wires Upside Engine to your scene.
- `ServerScriptService`: Server-side scripts (empty by default, ready for customization).
