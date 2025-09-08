function runManual()
	cui.pushTabWindow("manual", 0, 50, 1020, 440, true)
	ui.pushTextWrapPosition(1000 * cui.scaleY())

	ui.pushFont(ui.Font.Title)

	ui.treeNode("Extended Controls App Installation", function()
		ui.dwriteText(
			[[
To set up the "EXTENDED CONTROLS" app, follow these updated steps:

1. Since the app is now part of the CSP App Shelf, there's no need for manual installation. Simply ensure that CSP is up-to-date, and the app will be automatically included.
2. Locate the "App Shelf" in the in-game UI apps menu.
3. In the App Shelf, find VRC's Extended Controls app and click on it.
4. You will be prompted with a message to install the app. Simply click "Install," and that's it.
5. Once installed, you will find the Extended Controls app among all other UI apps.

This integration ensures that you always have the latest version of the app, with updates handled automatically by CSP. This streamlined installation process not only simplifies setup but also ensures you always benefit from the latest enhancements and fixes.
	]],
			14 * cui.scaleY()
		)
	end)

	ui.treeNode("Starting The Car", function()
		ui.dwriteText(
			[[
To start the car in the game, you need to do it manually. We have provided many ways to do this:

 1. (Steering Wheel Preferred Method): assign the "IGNITION" and “STARTER” bindings with the Extended Controls App.
 2. Clicking the “ACTIVATE” button next to the respective control in the Extended Controls App.
 3. (Gamepad/Keyboard Preferred Method): Clicking the “IGNITION” and “STARTER” bindings with the VRC Car Cockpit Controls app. This app also has bindings for navigating the cockpit control options with your input of choice, which can be bound in Extended Controls under the Apps->VRC Advanced Setup tab.
 4. In the CSP Unbound app, you can click the Extra A and Extra B buttons to control ignition and starter respectively.

We included this functionality due to the implementation of torque maps, which are discussed in more detail below. The engine's idle behavior has been revamped, and its RPM stays at around 3600 rpm in a lifelike manner. Once the Ignition is turned ON, you can then use the "Starter" assigned button to start the engine.
	]],
			14 * cui.scaleY()
		)
	end)

	ui.treeNode("Deployment Strat Mapping", function()
		ui.dwriteText(
			[[
This car utilizes the new ERS mapping function included with the VRC Advanced Setup app. If you installed the car following the instructions on page 3 of this manual, the app should automatically install and open each time you enter the car’s setup menu. This function allows you to define areas of the circuit where electric power can be deployed.

There are three modes to distinguish:
 - Cyan: 	Areas where the battery (ES) powers the MGU-K to deliver 120 kW.
 - Red: 	Areas where the ES powers the MGU-K to deliver 120 kW and also spins the turbo to deliver maximum power. This mode is very power-intensive and should be used sparingly, ideally at the beginning of straights.
 - White: 	Areas where the car will be recovering energy to be deployed later.

ERS maps can be either automatically generated or user-defined. Automatically generated maps are not optimal, so it is recommended to create your own maps for better performance.
You can break down the circuit into multiple “splits.” A split is defined by a starting position and a deployment length.

Once defined, maps will be automatically saved to the corresponding “STRAT MAPS” that can be selected in the setup menu or while driving (you will need to bind a key in Extended Controls for this).
	]],
			14 * cui.scaleY()
		)
	end)

	ui.treeNode("Brake Shape Mapping", function()
		ui.dwriteText(
			[[
In this section of the VRC Advanced Setup app, you can define brake migration shapes based on the front brakes' torque:

 - Brake Bias: This is the peak brake bias that will be achieved at and after Front Brake Ramp End Torque is reached.
 - Brake Shape Map:	Allows you to select between different brake shape presets.
 - Brake Migration: The percentage the overall brake bias will shift rearwards as the front brake torque approaches the Ramp Start Torque. For example, if you have 5% brake migration and a peak brake bias of 56%, it means that as front braking torque increases, brake bias will vary from 51% to 56%.
 - Front Brake Ramp Start Torque: This is the front brake torque at which brake migration will start.
 - Front Brake Ramp End Torque: This is the front brake torque at which peak brake bias will be reached.

You can visualize the brake shapes on the graph, with the selected brake shape highlighted in red.

You also have several options for managing your maps:
 - Use the “Clear” button to clear the map (right-click to clear all shapes).
 - Use the “Copy/Paste” button to copy a shape from the currently selected shape map to another (right-click to copy to all other maps).
 - Use the “Reset” button to revert to the default configuration.

]],
			14 * cui.scaleY()
		)
	end)

	ui.popFont()

	ui.popTextWrapPosition()

	cui.dummy(15, 15)
	cui.popTabWindow()
end
