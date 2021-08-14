%%%% This is the main function to control the motor
clear all
close all
motor = StandaMotor;

motor.initializeDevices();  %% initialize the motor

motor.rotationRelative(360);  %% rotate 360 degree (one full cycle ) clockwise
motor.rotationRelative(-180); %% rotate 180 degree anticlockwise

motor.goHome();  %% go back to initial position

motor.closeDevices();  %% Close the motor


