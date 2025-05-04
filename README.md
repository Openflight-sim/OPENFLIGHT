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
