%%% +DevicePack contains all the class in a more concise way
%%% All the necessary class are in seperate folder 


clear all
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test the motor 
motorAxis1 = DevicePack.StandaMotor();   %% instantiation of the motor object

%% Get the devices ids
motorAxis1.getDevicesId();

%% Set the motor id (1 or 2: check which one is working)
motorAxis1.setMotorId(1); 
%motor.setMotorId(2);

%%
motorAxis1.rotationRelative(50*360);
%%
motorAxis1.goHome();
%%
motorAxis1.closeDevices();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Test the Dac
% % dq = DevicePack.Dac();  %% instantiation of the Dac object
% % dq.putVoltage(0.2, 0.5);
% % dq.goHome();
% % dq.closeDevices();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test the camAndorZyla

camZyla = DevicePack.camAndorZyla; 

%%
% % camZyla.setROI(1776, 1760);
camZyla.setROI(1392, 1040);
% % camZyla.setROI(528, 512);






%% Test the pco.panda camear
camPanda = DevicePack.camPcoPanda;

%%
% % camPanda.getExposureTime();
% % camPanda.setExposureTime(5);
img = camPanda.getImageFrame();  %% take a single image
figure, imagesc(img)

%% Grab certain number of images
numberOfImage = 10;
imge = zeros(size(img,1), size(img, 2), numberOfImage);
tic
for ii = 1: numberOfImage
    imge(:,:,ii) = camPanda.getImageFrame();
    disp(ii);
end
toc

%% Shut down the and unload the camera library
camPanda.closeDevices();

%% Test the photon focus camera
cam = DevicePack.camPhotonFocus;

%%
cam.setExposureTime(20);
figure, imagesc(cam.getImageFrame());

%% Close the camera object
cam.closeDevices();




%% Test the LASER source
%% Instantiate the object LASER
laser = DevicePack.NKTPLaser;

%% Trun ON the laser
laser.turnONdevice();

%% Set the power level of the LASER
laser.setPowerLevel(50);  %% set the power level to 50 percent

%% Turn OFF the LASER
laser.closeDevices();




%%
Data = DevicePack.SaveData;