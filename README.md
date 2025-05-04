# OpenFlight Simulator Project Summary

## Overview

OpenFlight is a flight simulator project featuring a Julia backend for physics simulation and a JavaScript frontend for 3D visualization using Babylon.js. The simulation employs a 6-Degrees-of-Freedom (6-DOF) model and communicates between the backend and frontend in real-time via WebSockets.

## Core Components

1.  **Julia Backend (`✈_OPENFLIGHT/OpenFlight.jl`)**:
    * **Simulation Engine**: Implements the core physics using a Runge-Kutta 4 (RK4) integrator (`2.1_⭐_Runge_Kutta_4_integrator.jl`) to solve the 6-DOF equations of motion (`2.2_🤸‍♀️_compute_6DOF_equations_of_motion.jl`).
    * **Aerodynamic Model**: Loads aircraft-specific aerodynamic and propulsive data from YAML files (`0.1_📊_aircraft_aerodynamic_and_propulsive_data.jl`, `0.2.4_📈_get_constants_and_interpolate_coefficients.jl`). Calculates aerodynamic forces (`0.2.1_▶...`), moments (`0.2.2_⏩...`), and thrust (`0.2.3_🚀...`) based on flight conditions (Mach, alpha, beta, etc.) derived from the aircraft state (`2.4_📶...`).
    * **Atmosphere & Constants**: Includes models for the ISA Standard Atmosphere (`4.2_🌍_ISA76.jl`), physical constants (`4.1_🎯...`), and anemometry calculations (`4.3_🕑...`).
    * **Control Dynamics**: Simulates actuator and engine spooling dynamics (`5.1_➰...`) to model realistic control response times.
    * **WebSockets Server**: Establishes a WebSocket connection (`3.1_🤝...`), receives state and control inputs from the client, runs the simulation step, and sends the updated state back (`3.2_🔁...`). Automatically finds a free port (`🔌_Find_free_port.jl`) and updates the client configuration.
    * **Data Recording**: Records detailed flight telemetry data to a timestamped CSV file during a configurable time window (`3.3_📈...`).
    * **Client Launcher**: Automatically launches the default web browser to open the frontend HTML file (`3.0_🌐...`).
    * **Utilities**: Includes functions for quaternion math, coordinate transformations (`1.1_🔮...`), package management (`🎁...`), and syncing mission parameters from a YAML file (`default_mission.yaml`) to the JavaScript frontend (`✨...`).

2.  **JavaScript Frontend (`✈_OPENFLIGHT/src/🟡JAVASCRIPT🟡/✅_front_end_and_client.html`)**:
    * **3D Rendering**: Uses Babylon.js to render the 3D environment, aircraft model, and visualizations. Includes necessary Babylon.js libraries (Core, GUI, Loaders, Materials) and the Cannon.js physics engine (likely for client-side collision detection or effects).
    * **Scene Setup**: Creates the Babylon.js scene (`6.2_🌄...`), sets up lighting and shadows (`6.3_💡...`), and multiple camera views (ArcRotate, Follow, Cockpit, Wing) with controls to switch between them (`6.4_🎦...`).
    * **World Generation**: Creates the 3D world scenery (`4.1_🌍...`) including:
        * Procedural terrain with height calculated (`4.2.1_🏞...`) and colored based on altitude/slope (`4.2.2_🗺...`).
        * A procedurally textured runway conforming to terrain undulations (`4.2.3_🎹...`).
        * A dynamic sky sphere and fog (`4.2.4_🌖...`).
        * Various world objects like a control tower (`4.3.2_⛽...`), trees (using thin instances for performance) (`4.3.3_🌲...`), generic buildings (`4.3.1_🏠...`, `4.3.4_⛪...`), lighthouses with Morse code lights (`4.3.5_🗼...`), blinking lights (`4.3.6._💡...`), wind turbines with animated rotors (`4.3.7_💨...`), and a static car (`4.3.8_🚗...`).
    * **Aircraft Visualization**: Displays either a simple default aircraft model (`4.1_✈...`) or loads a user-provided `.glb` model (`4.3_🔼...`). Handles transformations (scaling, rotation, translation) specific to known `.glb` filenames and positions accessories like lights and propellers accordingly. Includes animated propeller and navigation/strobe lights.
    * **GUI**: Provides an interactive GUI using Babylon.GUI (`2.1_📟...`) to display flight data (position, altitude, speed, alpha/beta, FPS), control inputs, and provides buttons for pausing and loading aircraft models. Includes a help panel showing controls.
    * **Input Handling**: Captures keyboard and gamepad/joystick inputs (`3.1_🕹...`) for flight control (pitch, roll, yaw, thrust) and simulation control (pause, camera change, reset).
    * **WebSockets Client**: Connects to the Julia backend (`1.1_🔁...`), sends pilot inputs and current (client-side predicted) state, and receives authoritative state updates from the server to synchronize the simulation.
    * **Data Visualization**: Draws debug lines for velocity and force vectors (`5.1_📐...`) and visualizes the aircraft's path with a trajectory trail (`5.2_➰...`).
    * **Initialization**: Sets up initial simulation parameters and state variables (`0.1_🧾...`), some of which are overridden by values synced from the Julia backend's mission file.


## Workflow

1.  The main Julia script `OpenFlight.jl` is executed.
2.  It checks dependencies, finds a free port, loads aircraft/mission data, updates the JS configuration, launches the browser with the frontend HTML, and starts the WebSocket server.
3.  The JavaScript frontend loads, initializes Babylon.js, connects to the WebSocket server.
4.  The frontend sends user inputs and state estimates to the backend via WebSockets.
5.  The Julia backend receives the data, runs the 6-DOF RK4 physics simulation step, calculates forces/moments, handles actuator dynamics, and sends the updated, authoritative state back to the frontend.
6.  The frontend receives the updated state and adjusts the 3D aircraft model's position and orientation, updates GUI elements, and renders the scene.
7.  Flight data is logged to a CSV file by the Julia backend during the specified time interval.


OpenFlight Simulator - Installation Guide for Development
This guide will walk you through setting up the OpenFlight simulator project on your local machine for development purposes.

1. Prerequisites
Operating System: Windows, macOS, or Linux. Instructions may vary slightly depending on your OS.
Git: You need Git installed to download (clone) the repository. If you don't have it, download and install it from git-scm.com.
2. Download the Repository
Open a Terminal or Command Prompt:
Windows: Open Command Prompt (cmd) or PowerShell.
macOS: Open Terminal (Applications > Utilities > Terminal).
Linux: Open your preferred terminal emulator.
Navigate to your Development Directory: Choose a location on your computer where you want to store the project files. Use the cd command to navigate there.
Bash

# Example: Create and navigate to a 'dev' folder in your home directory
cd ~
mkdir dev
cd dev
Clone the Repository: Use git clone followed by the repository URL (replace the placeholder URL with the actual one for OpenFlight):
Bash

git clone https://github.com/YourUsername/OpenFlight.git
This command creates a new folder named OpenFlight (or similar, depending on the repo name) containing all the project files.
Navigate into the Project Folder:
Bash

cd OpenFlight
You should now be inside the main project directory.
3. Install Julia
Julia is the language used for the backend simulation engine.

Download Julia: Go to the official Julia language download page: julialang.org/downloads/
Choose Version: Download the current stable release (e.g., v1.10.x or later as of May 2025). Avoid alpha or beta versions unless you have a specific reason.
Install Julia: Run the installer you downloaded.
(IMPORTANT) During installation, ensure you select the option to "Add Julia to PATH" or similar. This allows you to run Julia from any terminal window and helps VS Code find it automatically.
Verify Installation: Open a new terminal/command prompt window and type:
Bash

julia --version
You should see the installed Julia version printed (e.g., julia version 1.10.2). If you get an error, the PATH variable might not be set correctly; consult the Julia installation documentation for your OS.
4. Install Visual Studio Code (VS Code)
VS Code is a recommended code editor for working with this project.

Download VS Code: Go to the official VS Code website: code.visualstudio.com/
Install VS Code: Download the installer for your operating system and run it. Follow the on-screen instructions.
5. Install VS Code Extensions
Extensions enhance VS Code's functionality for specific languages and file types.

Launch VS Code.
Open the Extensions View: Click the Extensions icon in the Activity Bar on the side of the window (it looks like square blocks), or press Ctrl+Shift+X.
Search for and Install the following extensions:
Julia Language Support:
Search for Julia.
Install the extension published by julialang (ID: julialang.language-julia). This provides syntax highlighting, code completion, linting, debugging, and integration with the Julia REPL.
YAML:
Search for YAML.
Install the extension published by Red Hat (ID: redhat.vscode-yaml). This helps with editing the .yaml configuration files used in the project (like default_mission.yaml and aircraft data files).
6. Configure Julia Environment in VS Code
Open the Project Folder:
In VS Code, go to File > Open Folder...
Navigate to and select the OpenFlight folder you cloned earlier.
Verify Julia Path (Usually Automatic):
The Julia extension should automatically detect your Julia installation if it was added to the system PATH correctly. You might see a message in the status bar indicating the Julia environment is loading.
If Detection Fails: If the extension cannot find Julia, you may need to set the path manually:
Press Ctrl+Shift+P to open the Command Palette.
Type Preferences: Open User Settings (JSON) and select it.
Add or modify the julia.executablePath setting, pointing it to your Julia executable. The path format depends on your OS and installation location. Examples:
Windows: "julia.executablePath": "C:\\Users\\YourUser\\AppData\\Local\\Programs\\Julia-1.10.2\\bin\\julia.exe" (adjust version and path)
macOS: "julia.executablePath": "/Applications/Julia-1.10.app/Contents/Resources/julia/bin/julia"
Linux: "julia.executablePath": "/usr/local/bin/julia" or wherever you installed it.
Remember to use double backslashes (\\) in JSON strings on Windows.
Save the settings.json file and potentially restart VS Code.
7. First Run and Dependency Installation
The project is designed to automatically handle Julia package dependencies on the first run.

Open the Integrated Terminal in VS Code:
Go to Terminal > New Terminal or press Ctrl+`.
Make sure the terminal's current directory is the OpenFlight project folder.
Run the Main Julia Script: Type the following command in the terminal and press Enter:
Bash

julia OpenFlight.jl
Wait for Package Installation:
The first time you run this, Julia's package manager (Pkg) will be invoked by the 🎁_load_required_packages.jl script included in OpenFlight.jl.
It will check for the required packages (HTTP, WebSockets, JSON, YAML, CSV, DataFrames, etc.).
If any packages are missing, it will automatically download and install them. This process can take several minutes, especially the first time, as packages need to be downloaded and precompiled. You will see output messages in the terminal related to package operations.
Simulator Launch:
Once packages are installed and loaded, the script should:
Find an available network port for WebSockets.
Update the necessary JavaScript configuration file (0.1_🧾_initializations.js).
Launch your default web browser, opening the ✅_front_end_and_client.html file.
Start the WebSocket server, displaying messages like "Starting WebSocket server on port xxxx..." and "Server running...".
Check the Browser: The OpenFlight simulator frontend should load in your browser. You might need to wait a moment for the WebSocket connection to establish between the frontend and the backend.
8. Starting Development
You are now set up to run and develop the OpenFlight simulator!

Editing: Use VS Code to edit both the Julia (.jl) and JavaScript (.js), HTML (.html), and CSS (.css) files. The installed extensions provide syntax highlighting and other language features.
Running: To run the simulator after making changes, simply execute julia OpenFlight.jl in the VS Code integrated terminal again.
Julia REPL: You can use the integrated Julia REPL in VS Code for testing snippets of Julia code (Ctrl+Shift+P -> Julia: Start REPL).
Configuration:
General simulation settings (initial conditions, visualization flags) can often be adjusted in src/🟡JAVASCRIPT🟡/0_INITIALIZATION/0.1_🧾_initializations.js.
Mission-specific settings (aircraft used, data recording times) are typically in default_mission.yaml.
Aircraft aerodynamic data is stored in .yaml files within the 🏭_HANGAR/📜_Aero_data/ directory.
You have successfully installed and configured the necessary tools to develop the OpenFlight simulator. Happy coding and flying!
