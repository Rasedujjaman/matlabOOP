%%% Main function for the camera

clear all
close all

%% Instantiate the camera object
camZyla = Camera; 
 
%% set the ROI (select any one)
% % camZyla.setROI(1776, 1760);
camZyla.setROI(1392, 1040);
% % camZyla.setROI(528, 512);

%%
%%%%%% Take the snapshot
 figure, imagesc((camZyla.getImageFrame)'), colorbar


%%
%%%%%%Take multiple snapshot
numIlluminaiton = 5;
sleep_time = 0.00;

temp_data = zeros(camZyla.getImageWidth, camZyla.getImageHeight);
scan_data = repmat(temp_data, [1, 1, numIlluminaiton]);
tic
for ii = 1: numIlluminaiton

    temp_data = camZyla.getImageFrame();
    scan_data(:,:,ii) = temp_data;
    
    pause(sleep_time); % sleep time to settle the galvano mirrors
end
toc

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Shut down camear
camZyla.shutDownCamera();
clear camZyla;  %% delete the object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Display the image
figure,imagesc(scan_data(:,:,1));


