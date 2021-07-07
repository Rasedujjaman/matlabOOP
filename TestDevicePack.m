%%% +DevicePack contains all the class in a more concise way
%%% All the necessary class are in seperate folder 


clear all
close all;

%% Test the motor 
motor = DevicePack.StandaMotor();   %% instantiation of the motor object
motor.initializeDevices();
motor.rotationRelative(5*360);
motor.goHome();
motor.closeDevices();



%% Test the Dac
dq = DevicePack.Dac();  %% instantiation of the Dac object
dq.putVoltage(0.2, 0.5);
dq.goHome();
dq.closeDevices();



