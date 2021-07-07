%%% Main program to drive the setup

clear all
close all

%% Instantiate the camera object, Dac object, StandaMotor object
camZyla = Camera; 
dq = Dac;
motor = StandaMotor;  
 
%% set the ROI (select any one)
% % camZyla.setROI(1776, 1760);
camZyla.setROI(1392, 1040);
% % camZyla.setROI(528, 512);

%% Initialize the motor
motor.initializeDevices();

%% Set the motor speed
motor.setRotationSpeed(5000);

%% Load the scane voltage and phi angle for motor
load scanVoltCir.mat
load phiOutmost.mat
phi = th_outmost./2;
voltCh0 = volt_th_outmost_ch0;
voltCh1 = volt_th_outmost_ch1;


%%
numIlluminaiton = size(voltCh0,2);
sleep_time = 0.5;

temp_data = zeros(camZyla.getImageHeight, camZyla.getImageWidth);
% % temp_data = zeros(camZyla.getImageWidth, camZyla.getImageHeight);


scan_data = repmat(temp_data, [1, 1, numIlluminaiton]);
tic
for ii = 1: numIlluminaiton

    dq.putVoltage(voltCh0(ii),voltCh1(ii));
    motor.rotationRelative(10);
% %     motor.rotationAbsolute(phi(ii));
    pause(sleep_time); % sleep time to settle the galvano mirrors
    temp_data = camZyla.getImageFrame();
    scan_data(:,:,ii) = temp_data';
    
end
toc

motor.goHome();
dq.putVoltage(0, 0);

%% Take the sanp
ref = (camZyla.getImageFrame())';

%% Save the scan data
save('scan_data', 'scan_data', 'ref');


%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Shut down camear
camZyla.shutDownCamera();
clear camZyla;  %% delete the object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Shut down the motor
motor.closeDevices();
clear motor;

%% Close the Dac
dq.closeDevices();

%% Display the image
figure,imagesc(scan_data(:,:,1));


