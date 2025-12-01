# roblox-upside-engine-starter

A barebones starter project for using Upside Engine to do 2D game development in Roblox.

## Getting Started

### End-to-end Roblox Studio workflow (Git as the source of truth)

1. **Install Roblox Studio and Rojo**
   - Install [Roblox Studio](https://create.roblox.com/). Sign in so your place can save to the cloud.
   - Install the **Rojo** CLI from the latest release for your platform: https://github.com/rojo-rbx/rojo/releases. Add it to your `PATH` so `rojo --version` works in a terminal.

2. **Install the Rojo plugin in Studio**
   - In Roblox Studio, open **Plugins → Manage Plugins → Toolbox**, search for **Rojo**, and install the official plugin by Roblox (the same authors as the CLI).
   - Restart Studio if prompted.

3. **Clone this repository**
   ```bash
   git clone https://github.com/your-org/roblox-upside-engine-starter.git
   cd roblox-upside-engine-starter
   ```

4. **Start a Rojo sync server from the repo**
   - This repository includes `default.project.json` mapping the repo folders to their Roblox services.
   - Run Rojo in watch/sync mode:
     ```bash
     rojo serve
     ```
   - Keep this terminal running. It exposes the project on port **34872** (the plugin default).

5. **Create/open a place in Roblox Studio and attach Rojo**
   - Open a new Baseplate (or your target experience). Save it to Roblox or to a local `.rbxl` file—either works because Rojo writes into the open session.
   - In Studio, open **Plugins → Rojo** and click **Connect** (it should auto-detect `localhost:34872`).
   - After connecting, Rojo will sync the repo contents into the live Studio session, creating/updating `ReplicatedStorage`, `StarterPlayer`, and `ServerScriptService` from the repository files.

6. **Edit locally, use Studio for playtesting**
   - Make code changes in your local editor (VS Code, etc.). Rojo will live-sync them into the running Studio session for play testing.
   - When you are satisfied, commit your changes to Git; the repository remains the source of truth.
   - If you temporarily tweak code in Studio, click **Pull** in the Rojo plugin to re-apply the repo version so Studio stays in sync with Git.

7. **Publishing/sharing the experience**
   - To push your latest repo state into a fresh Studio session (or another machine), just repeat steps 4–5. The Rojo sync will overwrite the Studio copy with the Git-controlled files.
   - To upload a distributable model of the game, run:
     ```bash
     rojo build --output build/UpsideEngineStarter.rbxm
     ```
     Then insert the generated `.rbxm` into a place via **Asset Manager → Bulk Import** or **View → Toolbox → My Models**.

> Tip: Keep Studio’s **Team Create** enabled if you collaborate, but rely on Git + Rojo to move code between machines. Team Create saves the place to the cloud, while Rojo keeps the code synchronized from the repository.

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
