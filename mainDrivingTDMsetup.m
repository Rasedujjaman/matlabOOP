%%% Main program to drive the setup

clear all
close all

%% Instantiate the camera object, Dac object, StandaMotor object
camZyla = Camera; 
dq = Dac;
% motor = StandaMotor;  
 
%% set the ROI (select any one)
% % camZyla.setROI(1776, 1760);
camZyla.setROI(1392, 1040);
% % camZyla.setROI(528, 512);

%% Initialize the motor
motor.initializeDevices();


%% Load the scane voltage
load scanVoltSnk.mat


%%
numIlluminaiton = size(voltage_ch0_scan,1);
sleep_time = 0.2;

temp_data = zeros(camZyla.getImageHeight, camZyla.getImageWidth);
% % temp_data = zeros(camZyla.getImageWidth, camZyla.getImageHeight);


scan_data = repmat(temp_data, [1, 1, numIlluminaiton]);
tic
for ii = 1: numIlluminaiton

    dq.putVoltage(voltage_ch0_scan(ii),voltage_ch1_scan(ii));
    pause(sleep_time); % sleep time to settle the galvano mirrors
    temp_data = camZyla.getImageFrame();
    scan_data(:,:,ii) = temp_data';
    
end
toc

%% Save the scan data
dq.putVoltage(0, 0);
save('scan_data', 'scan_data');


%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Shut down camear
camZyla.shutDownCamera();
clear camZyla;  %% delete the object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Shut down the motor
motor.closeDevices();
clear motor;


%% Display the image
figure,imagesc(scan_data(:,:,1));


