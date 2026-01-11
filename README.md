[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.5.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)
[![License](https://img.shields.io/github/license/dragonforge-dev/dragonforge-game-template?logo=mit)](https://github.com/dragonforge-dev/dragonforge-game-template/blob/main/LICENSE)
[![GitHub release badge](https://badgen.net/github/release/dragonforge-dev/dragonforge-game-template/latest)](https://github.com/dragonforge-dev/dragonforge-game-template/releases/latest)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-game-template)](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-game-template)

# Dragonforge Game Template
A Godot game template for game jams.
# Version 0.9
For use with **Godot 4.5-stable** and later.
## Dependencies
The following dependencies are included in the addons folder and are required for the template to function.
- [Dragonforge Controller 0.13](https://github.com/dragonforge-dev/dragonforge-controller)
- [Dragonforge Disk (Save/Load) 0.6](https://github.com/dragonforge-dev/dragonforge-disk)
- [Dragonforge Display 0.14.2](https://github.com/dragonforge-dev/dragonforge-display)
- [Dragonforge Sound 0.15](https://github.com/dragonforge-dev/dragonforge-sound)
- [Dragonforge State Machine 0.5](https://github.com/dragonforge-dev/dragonforge-state-machine)
- [Dragonforge User Interface 0.1.3](https://github.com/dragonforge-dev/dragonforge-user-interface)
# Installation Instructions
1. Copy all the folders from the `addons` folder into your project's `addons` folder.
2. Ignore the following errors (they are appearing because the component is not yet enabled):
  * ERROR: res://addons/dragonforge_controller/controller.gd:54 - Parse Error: Identifier "Keyboard" not declared in the current scope.
  * ERROR: res://addons/dragonforge_controller/controller.gd:56 - Parse Error: Identifier "Mouse" not declared in the current scope.
  * ERROR: res://addons/dragonforge_controller/controller.gd:59 - Parse Error: Identifier "Gamepad" not declared in the current scope.
  * ERROR: modules/gdscript/gdscript.cpp:3022 - Failed to load script "res://addons/dragonforge_controller/controller.gd" with error "Parse error".
3. In your project go to **Project -> Project Settings...**
4. Select the **Plugins** tab.
5. Check the **On checkbox** under **Enabled** for **Dragonforge Disk** (must be enabled **before** the Display and Sound plugins or you will get errors).
6. Check the **On checkbox** under **Enabled** for **Dragonforge Display**.
7. Check the **On checkbox** under **Enabled** for **Dragonforge Sound**.
8. Check the **On checkbox** under **Enabled** for **Dragonforge Controller**
9. Check the **On checkbox** under **Enabled** for **Dragonforge User Interface**
10. Check the **On checkbox** under **Enabled** for **Dragonforge Game Template**
11. Press the **Close** button.
12. Save your project.
13. In your project go to **Project -> Reload Current Project**.
14. Wait for the project to reload.

**NOTE:** It's important to reload the project after running the plugin because it updates the `ui_accpet` action, and creates three new actions: `back_button`, `skip`, and `pause`. Once you reboot, you can edit these actions as you wish, but disabling and re-enabling them will reset them.

# FAQ
## Why a plugin?
I felt it was important to be able to update existing games with new features from this code. The easiest way to do that is to create an addon/plugin because then it is clear how to use it and makes it easy to upgrade. If this was a template to start a game that you modified, then any further updates would be much harder to add in.

A plugin also helps in game jams where one may decide tlater to add these features in. When you don't have a lot of time, it's good for using something like this to be as seamless as possible.

# Usage Instructions
There is an example folder that contains an example level and player for loading a level. This is what will load when you first import the template. Note that while it loads a 2D level and charcter, this template works with 3D games as well.
## Themes
Version 0.8 introduced themes. There are two, `default` and `fantasy`, Applying them to the **Theme** node in `main.tscn` under the **Main Menu Game State**. They are located in `res://ui/themes/`

## Example 2D
The folder found at `res://example_2d/` contains example code for a 2D game. These instructions assume you have already followed the installation instructions above.
1. Copy the `example_2d` folder from the root of this project to your project.
2. **In your project** open `res://addons/dragonforge_game_template/game_configuration.tscn` (You should have already copied this over during installation.)
3. In the **Inspector** under **GameConfiguration** select the **File** button next to **Main Scene**.
4. **In your project** browse to `res://example_2d/game_template_files/main.tscn` and select it.
5. Press **Ok**.
6. In the **Inspector** under **GameConfiguration** select the **File** button next to **Game Scene**.
7. **In your project** browse to `res://example_2d/game_template_files/game.tscn` and select it.
8. Press **Ok**.
9. Go to **Project -> Project Settings...**
10. Select the **Plugins** tab.
11. Uncheck the **On checkbox** under **Enabled** for **Dragonforge Game Template**
12. Check the **On checkbox** under **Enabled** for **Dragonforge Game Template**
13. Press the **Close** button.
14. Save your project. (You do not need to reload the project at this time despite the warning message.)

### Test the 2D Installation
1. Press the **Run Project** button (or use F5). The game will start.
2. You should see and hear the template default Godot splash screen video. (You can change or delete this later.)
3. You should see and hear the Dragonforge splash screen. (You can delete this later.)
4. The main screen should load and the **Dragonforge Theme Song** should play.
5. Press the New Game button.
6. A game scene will load with the Godot background and a red Godot logo. You should also hear game music.
7. Using the **arrow keys** or gamepad **left joystick** will move the red Godot logo.
8. Pressing the **Escape** key or **Start** button on your gamepad will pause the game and show the main menu.

## Example 3D
The folder found at `res://example_3d/` contains example code for a 3D game.
1. Copy the `example_3d` folder from the root of this project to your project.
2. **In your project** open `res://addons/dragonforge_game_template/game_configuration.tscn` (You should have already copied this over during installation.)
3. In the **Inspector** under **GameConfiguration** select the **File** button next to **Main Scene**.
4. **In your project** browse to `res://example_3d/game_template_files/main.tscn` and select it.
5. Press **Ok**.
6. In the **Inspector** under **GameConfiguration** select the **File** button next to **Game Scene**.
7. **In your project** browse to `res://example_3d/game_template_files/game.tscn` and select it.
8. Press **Ok**.
9. Go to **Project -> Project Settings...**
10. Select the **Plugins** tab.
11. Uncheck the **On checkbox** under **Enabled** for **Dragonforge Game Template**
12. Check the **On checkbox** under **Enabled** for **Dragonforge Game Template**
13. Press the **Close** button.
14. Save your project. (You do not need to reload the project at this time despite the warning message.)

### Test the 2D Installation
1. Press the **Run Project** button (or use F5). The game will start.
2. You should see and hear the template default Godot splash screen video. (You can change or delete this later.)
3. You should see and hear the Dragonforge splash screen. (You can delete this later.)
4. The main screen should load and the **Dragonforge Theme Song** should play.
5. Press the New Game button.
6. A game scene will load with an box of grey and brown, and a 3D Godot logo robot. You should also hear game music.
7. Using the **arrow keys** or gamepad **left joystick** will move the Godot robot. (There are no animations.)
8. Pressing the **Escape** key or **Start** button on your gamepad will pause the game and show the main menu.

### map_level.gd
Extends **Node2D** (can easily be changed to extend **Node3D**.) It can be used as a base for your own levels.
#### Export Variables
- `spawn_point: Node2D` A **Node2D** that is used for spawning the player if they do not have one. (Typically the starting point for the game. This can easily be changed to a **Node3D**. and used the exact same way.
- `level_music: Song` A **Song** can be added here and will automatically begin playing when the level loads, and paused when the game is paused. Note **Song** is a **Resource** in the **Sound** plugin. This can easily be changed to an **AudioStream**.

## Game Configuration
Located in `res://addons/dragonforge_game_template/`, this node is just an interface to make it easy to change your game's **Game** autoload and **Main** scene. Both of these default to the versions in `res://addons/dragonforge_game_template/`.

### Game
To update the **Game** autoload and customize it do the following:

1. Following the installation instructions and reload the project.
2. Copy `game.tscn` and `game.gd` from `res://addons/dragonforge_game_template/` into your project.
3. Open `game.tscn`.
4. Click one the **Game** node.
5. Click the **Detach the script from the selected node.** button. (Icon is a script with a little red x on it.)
6. Click the **Attach a new or existing script to the selected node.** button. (It's the same button, but now the icon is a script with a little green plus on it.)
7. Select the `game.gd` script you copied. (If you don't do this changes to the script will get overwritten when you update.)
8. Open `res://addons/dragonforge_game_template/game_configuration.tscn`
9. In the **Inspector** under **GameConfiguration** select the **File** button next to **Game Scene**.
10. Browse to the location where you put _your_ version of `game.tscn` and select it.
11. Press **Ok**.
12. Go to **Project -> Project Settings...**
13. Select the **Plugins** tab.
14. Uncheck the **On checkbox** under **Enabled** for **Dragonforge Game Template**
15. Check the **On checkbox** under **Enabled** for **Dragonforge Game Template**
16. Press the **Close** button.
17. Save your project. (You do not need to reload the project at this time despite the warning message.)

### Main
To update the **Main** scene that is started with the game and customize it, follow the instructions below. Note that you can do the same thing if you have your own scene you want to use as the start of your game instead, just skip to step 8. This will allow you to use that scene and ignore the scene the plugin tries to set.

1. Following the installation instructions and reload the project.
2. Copy `main_template.tscn` from `res://addons/dragonforge_game_template/` into your project. (We suggest `res://game_template_files/`)
3. Rename `main_template.tscn` to `main.tscn`.
4. Open `main.tscn`.
5. Rename the root node from **MainTemplate** node to **Main**.
6. Click on the **Main** node.
7. Click the **Detach the script from the selected node.** button. (Icon is a script with a little red x on it.)
8. Click the **Attach a new or existing script to the selected node.** button. (It's the same button, but now the icon is a script with a little green plus on it.)
9. Create a `main.gd` script. (If you don't do this changes to the script will get overwritten when you update.)
10. Add the following code to the script: `class_name Main extends MainTemplate`. (Delete all other code.)
11. Open `res://addons/dragonforge_game_template/game_configuration.tscn`
12. In the **Inspector** under **GameConfiguration** select the **File** button next to **Main Scene**.
13. Browse to the location where you put _your_ version of `main.tscn` and select it.
14. Press **Ok**.
15. Save your project. (You do not need to reload the project at this time despite the warning message.)

**NOTE:** This is no different than setting the value in **Project Settings -> Run**, however setting it here will retain the value if you update or disable/re-enable the plugin.

### Configuring Splash Screens
1. Open up your copied version of `main.tscn`.
2. Select the **Splash Screen** state node under **Game State Machine**.
3. In the **Inspector**, expand the **Active Splash Screens** array.
4. Add or remove **SplashScreen** nodes and/or change the order in which they appear.
5. To make your own custom splash screen, copy any of the existing screens and add them.
6. Delete any splash screens not needed. (They won't show up, but deleting them reduces the footprint of your initial load.)

## Configuring Main Menu Background
1. Open up your copied version of `main.tscn`.
2. Select the **Main Menu** state node under **Game State Machine**.
3. Add a new background using **Control** (UI) nodes.
3. In the **Inspector**, replace the **Background** variable with a reference to the root of your new background.


# Class Descriptions

## Game (Autoload)
By default, the **Game** autoload scene is loaded from the addon folder. `res://addons/dragonforge_game_template/game.tscn` This template inherits from **GameBase**. The reason for this is you will likely want to add your own custom signals, variables and even functions to **Game**. You can do this by copying the scene and script to somewhere in your project, and editing them. See **Game Configuration** for how to load your custom **Game** scene as the autoload..
#### Signals
- `signal splash_screens_complete` Splash screens have completed or been skipped.
- `signal start_cutscene(cutscene: String)` Tell a cutsene to start.
- `signal cutscene_finished` Current cutscene has finished.
- `signal load_level(level_name: String, player: Node, target_transition_area: String)` Load the passed level. (Null can be passed for the player and transition_area.)
#### Public Member Variables
- `is_loaded: bool = false` Whether or not game is loaded.
- `in_progress: bool = false` Starts out false. Becomes true when a new game is started, or a game is loaded. Saved to disk.
- `level_path: String` Path for loading the next level. Saved to disk.
#### Public Functions
Most of these functions are convenience methods, as they just call `get_tree()`. However they have been implemented to make code clearer. Also, the quit method actually sends out a quit signal before calling get_tree().quit(), just as if the user had closed the window.
- `quit() -> void` Quits the game, after notifying all nodes, which allows save on quit functionality. This should be used instead of get_tree.quit()
- `pause(pause: bool = true) -> void` Pauses or unpauses the game based on the boolean sent. Defaults to pausing the game. (*Convenience method.*)
- `unpause() -> void` Unpauses the game. (*Convenience method.*)
- `is_paused() -> bool` Returns whether or not the game is paused. (*Convenience method.*)

## Main
This scene, found at `res://addons/dragonforge_game_template/main.tscn`, is intended to be made the Main Scene. The plugin does this automatically. To load your main game scene, add it to the `starting_level` export variable. **NOTE:** You may want to copy this scene or inherit from it and place it somewhere else so that future changes you make are not overwritten by new versions of this plugin. See **Game Configuration** for how to load your custom **Main** scene to be compatible with plugin updates.
#### Export Variables
- `starting_level: String` The first game level to load and attach to the UI's start button. You can either paste in a path to the scene, or press the **Open a File** dialog button to the right of the text field and browse to the starting scene.
- `bypass_splash_screens_during_debug: bool = false` This is here in case we aren't allowing the player to skip the splash screens but we want to do so for testing. (See also GameStateSplashScreen.splash_screens_are_skippable.) It only affects debug builds of the game.

### Game State Machine
The Game State Machine is an unmodified **StateMachine**. It has a number of custom **State**s however. It comes configured to start the **GameStateSplashScreen** **State**, but that can be changed if desired.

### GameStateSplashScreen
This **State** handles playing all the splash screens in order, as will as handling requests from the `skip` action. This **State** is intended to run while the rest of the game is loading, and as such, it breaks the rules and has a `_ready()` function implementation. This is not best practice for **State** nodes, as it can lead to race conditions. *You have been warned.*
#### Export Variables
- `active_splash_screens: Array[SplashScreen]` All the splash screens to show, and the order to show them in. Add any **SplashScreen** nodes you want shown at the beginning of the game. Leaving this blank will cause the splash screen state to be skipped.
- `splash_screens_are_skippable: bool = true` If true, you can skip the splash screens using the `skip` action (which is automatically added when this plugin is activated) as long as you have viewed them once. See GameStateSplashScreen.splash_screens_viewed variable for more information. See also: Main.bypass_splash_screens_during_debug variable.
- `splash_screens_viewed: bool = false` Stores whether the user has seen the splash screens before. **Saved to disk.** Once this value is true, and as long as splash_screens_are_skippable remains true, the player may skip splash screens using the `skip` action (which is automatically added when this plugin is activated). This value resets to false if `configuration.settings` is deleted in the **UserData** folder. See also: Main.bypass_splash_screens_during_debug variable.
### SplashScreen Nodes
**SplashScreen** nodes are configured to be easy to implement and run. Currently there are 6 exmaples under the **GameStateSplashScreen** node. Two are Godot splash screens that use videos; one is the Dragonforge Development splash screen; and three are Game Jam splash screens. All are provided as examples. Only splash screens that are added to the **GameStateSplashScreen**'s' `active_splash_screens` array will be run. Once you have figured out which ones you want, you should delete the ones you don't need. You can also delete any files you don't need in `res://addons/dragonforge_game_template/assets/video/` and `res://addons/dragonforge_game_template/assets/textures/` - or exclude them from the export.
When making your own **SplashScreen**, it should be a child node of the **GameStateSplashScreen** like the others. The reason for this is once the splash screens are done playing (or skipped), the are deleted to save memory.

### GameStateLoading
This state handles level loading. It is entered when a level is requested to be loaded by emitting the `Game.load_level` signal. Once it starts, it displays a progress bar as the level loads. That scene can be edited by changing the **Loading Screen** **CanvasLayer** and children beneath it. It is recommended that you change the background, but not necessary.
It should be noted that the GameStateGameplay node is the one that actually starts the level once it is loaded, and so **GameStateLoading** has no control over when it is exited.

### GameStateGameplay
While the player is playing the game, this is the active state. Also note that while **GameStateMainMenu**, **GameStateCutscene**, and **GameStateDialogue** can run on top of this, even while paused **GameStateGameplay** stays visible.
This **State** starts monitoring when a level is requested to be loaded by emitting the `Game.load_level` signal. Then, once the loading is complete, this **State** takes over and actually starts the loaded level. The other way this **State** is entered is when the game is paused and the `pause` action is received. In which case the game is unpaused and this **State** is entered.

### GameStateMainMenu
This **State** monitors the `Game.splash_screens_complete` signal and takes over immediately. It is also entered when the game is unpaused and the `pause` action is received. In which case the game is paused and this **State** is entered.
**GameStateMainMenu** contains the game background for when the start menu loads. Changing that allows you to create a dynamic background, or just change it from the Godot logo. It also contains all of the menus as part of the **UserInterace** node.

# Localization
This project's UI has been created to work with localization. You can easily use localization by using the [Dragonforge Localization](https://github.com/dragonforge-dev/dragonforge-localization) plugin. The following labels exist and should be given translations:

- VOLUME
- MAIN
- MUSIC
- SOUND_EFFECTS
- DIALOGUE
- BACK
- DISPLAY_SETTINGS
- MONITOR
- FULLSCREEN
- RESOLUTION
- ZOOM_SCALE
- ACTION
- KEYBOARD
- MOUSE
- RESET
- SONG_TITLE
- ARTIST
- ALBUM
- PLAY
- NEXT
- PREVIOUS
- PAUSE
- NEW_GAME
- SETTINGS
- MUSIC_DISPLAY
- CREDITS
- QUIT_GAME
- RESUME_GAME
- RESUME_SAVED_GAME
