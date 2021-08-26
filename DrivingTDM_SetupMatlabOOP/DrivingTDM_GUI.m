
%%% Matlab GUI for driving the Tomographic diffractive microscopy(TDM)

%%Clear all
close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Connect to the devices
%%%Connect the AndorZyla camera
% % Camera = DevicePack.camAndorZyla; 
% % Camera.setROI(528, 512);

%%% Connect the photon focus camera
% % Camera = DevicePack.camPhotonFocus;



%%% 
 Camera = DevicePack.CameraPcoPanda;
 Camera.setROI(1024, 1024);
 
 
 %%% The Laser
 Laser = DevicePack.NKTPLaser;

 %%% The Dac
 Dq = DevicePack.Dac();


%%%The SacnPattern
ScanPattern = DevicePack.scanPattern();


%%% The Rotor
Rotator = DevicePack.StandaMotor();   %% The Rotator

%%% For data saving 
Data = DevicePack.SaveData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Size of the computer screen. The programm assumes a 16:9 ratio
%%% Chose one of the below ScreenWidth that fits well
ScreenWidth = 1680;
% % ScreenWidth = 1920;

%%%
ScreenHeigth = floor(ScreenWidth*9/16);
% Width of the command panel, on the left side
CommandWidth = floor(0.3*ScreenWidth);
% Heigth of 1 text lign
TextHeight = floor(ScreenHeigth/30);
TitleFontSize = floor(TextHeight*0.95);
TextFontSize = floor(TextHeight*0.6);
% space not to stick on the borders
SpaceSize = floor(TextHeight/6);

%% Colors
DarkGray = [0.4 0.4 0.4];

%% Create the main window
Main = uifigure();
% Name of of main window
Main.Name = 'DrivingTDM_GUI';
% Background color gray to limit brightness
% Main.Color = [0, 0, 0];      %% For Black color
Main.Color = [0.4 0.4 0.4];  %% For DarkGray color
% Window size equal to screen resolution
Main.Units = 'pixels';
% Fill the screen
Main.Position = [0 0 ScreenWidth ScreenHeigth];                          
Main.Resize = 'off';

%%
%% Create the area to display image
% Dummy Image
% % SensorSize = max(Camera.SensorWidth,Camera.SensorHeight); % Consider a full-size image from the camera
width = Camera.getImageWidth();
height = Camera.getImageHeight();



% % Image = zeros(SensorSize,SensorSize);                               
Image = zeros(width, height);
% % Image = zeros(width, height);
% % Image = zeros(1340, 1082);

CameraImage = uiaxes(Main); %% To display the live image
CameraImageKspace = uiaxes(Main); %% To display the k space image
% Position as [left bottom witdh heigth]. Here, we put the image on the right
% % CameraImage.Position = [CommandWidth 0 ScreenHeigth ScreenHeigth];  
CameraImage.Position = [0 0  floor(0.7*ScreenWidth)  ScreenHeigth]; 

CameraImageKspace.Position = [ceil(0.702*ScreenWidth) floor(0.65*ScreenHeigth)...
    floor(0.297*ScreenWidth) floor(0.35*ScreenHeigth)];
% Makes a full square around the image
CameraImage.Box='on';
CameraImageKspace.Box='on';

% Make sure x and y are same aspect ratio
% % CameraImage.DataAspectRatioMode='manual';
% % CameraImage.DataAspectRatio = [1 1 1];
% Set manual X and Y limits
% CameraImage.XLimMode = 'manual'; CameraImage.YLimMode = 'manual';
CameraImage.XLim = [0,width]; CameraImage.YLim = [0,height];
CameraImageKspace.XLim = [0,width]; CameraImageKspace.YLim = [0,height];

% % Display image the same way as ImageJ
% % CameraImage.XDir = 'normal'; CameraImage.YDir = 'reverse';
% % CameraImage.XAxisLocation = 'top'; CameraImage.YAxisLocation = 'left';
% Remove tick labels
CameraImage.XTick = []; CameraImage.YTick = [];
CameraImage.XTickLabel = []; CameraImage.YTickLabel = [];

CameraImageKspace.XTick = []; CameraImageKspace.YTick = [];
CameraImageKspace.XTickLabel = []; CameraImageKspace.YTickLabel = [];

% Display image in black and white
h =  imagesc(CameraImage,Image'); colormap(CameraImage,gray);
h2 = imagesc(CameraImageKspace, (log10(abs(fftshift(fft2(Image')))))); 
% Keep settings for next image
CameraImage.NextPlot='replacechildren';
CameraImageKspace.NextPlot='replacechildren';


%% Camera control panel
CameraPanel = uipanel(Main); 
CameraPanel.Units='pixels';
CameraPanelHeight = 4.8*TextHeight;
PanelHeightStart = floor(0.65*ScreenHeigth)- CameraPanelHeight;
PanelWidthtStart = floor(0.702*ScreenWidth);
% % CameraPanel.Position=[SpaceSize PanelHeightStart CommandWidth-2*SpaceSize CameraPanelHeight];

CameraPanel.Position=[PanelWidthtStart  PanelHeightStart ...
CommandWidth- SpaceSize  CameraPanelHeight];
CameraPanel.BorderType = 'line';
CameraPanel.BackgroundColor = [0.4660 0.6740 0.1880];
% Title
CameraPanel.FontSize = TitleFontSize;
CameraPanel.Title = 'CAMERA'; CameraPanel.TitlePosition = 'centertop';

HeightStart1 = CameraPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = SpaceSize;


% Live
CameraLiveButton = uibutton(CameraPanel,'state');
CameraLiveButton.Text = 'LIVE'; CameraLiveButton.FontWeight = 'bold'; CameraLiveButton.FontSize = TextFontSize;
CameraLiveButton.Position=[WidthStart HeightStart1 4.5*TextFontSize TextHeight]; 


HeightStart2 = HeightStart1 - 7*SpaceSize;
% Exposure Time
% Text "Exposure Time"
ExposureLabel = uilabel(CameraPanel);
ExposureLabel.Position=[WidthStart HeightStart2 6*TextFontSize TextHeight];
ExposureLabel.Text = 'Expo.(ms)'; ExposureLabel.FontWeight = 'bold'; ExposureLabel.FontSize = TextFontSize;
HeightStart3 = HeightStart2 - 6*SpaceSize;
% % Exposure Time
ExposureValue = uieditfield(CameraPanel,'numeric');
ExposureValue.Position = [WidthStart HeightStart3  5*TextFontSize TextHeight];
ExposureValue.ValueDisplayFormat = '%d';
ExposureValue.Value = 10; ExposureValue.FontWeight = 'bold'; ExposureValue.FontSize = TextFontSize;
ExposureValue.Limits = [0 Camera.ExpoTimeMax]; ExposureValue.LowerLimitInclusive = 'on'; ExposureValue.UpperLimitInclusive = 'on';
% Initialise with a 100 ms exposure time
% SetCameraExposure(Camera,100);
% WidthStart4 = WidthStart3+5*TextFontSize+2*SpaceSize;

% ROI

% Text "ROI"
ROILabel = uilabel(CameraPanel);

HeightStart = CameraPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = CommandWidth -3*TextHeight;
ROILabel.Position=[WidthStart HeightStart 3*TextFontSize TextHeight];
ROILabel.Text = 'ROI'; ROILabel.FontWeight = 'bold'; ROILabel.FontSize = TextFontSize;
WidthStart2 = WidthStart+3*TextFontSize;

% Text "Width"
ROIWidthLabel = uilabel(CameraPanel);
WidthStart = CommandWidth -4*TextHeight-3*SpaceSize;
HeightStart = CameraPanelHeight-3*TextHeight-3*SpaceSize;
ROIWidthLabel.Position=[WidthStart HeightStart 4*TextFontSize TextHeight];
ROIWidthLabel.Text = 'Width'; ROIWidthLabel.FontWeight = 'bold'; ROIWidthLabel.FontSize = TextFontSize;

% ROI width (numeric edit field )
ROIWidthValue = uieditfield(CameraPanel,'numeric');
% % WidthStart = CommandWidth -4*TextHeight-3*SpaceSize;
% % HeightStart = CameraPanelHeight-3*TextHeight-3*SpaceSize;

ROIWidthValue.Position = [WidthStart HeightStart3  3*TextFontSize TextHeight];
ROIWidthValue.ValueDisplayFormat = '%d';
ROIWidthValue.Value = Camera.getImageWidth(); ROIWidthValue.FontWeight = 'bold'; ROIWidthValue.FontSize = TextFontSize;
ROIWidthValue.Limits = [0  Camera.getSensorWidthMax()]; ROIWidthValue.LowerLimitInclusive = 'on'; ROIWidthValue.UpperLimitInclusive = 'on';



% Text "Height"
ROIHeightLabel = uilabel(CameraPanel);
WidthStart = CommandWidth -1*TextHeight-7*SpaceSize;
HeightStart = CameraPanelHeight-3*TextHeight-3*SpaceSize;
ROIHeightLabel.Position=[WidthStart HeightStart 4*TextFontSize TextHeight];
ROIHeightLabel.Text = 'Height'; ROIHeightLabel.FontWeight = 'bold'; ROIHeightLabel.FontSize = TextFontSize;

% % ROI height (numeric edit field)
ROIHeightValue = uieditfield(CameraPanel,'numeric');


ROIHeightValue.Position = [WidthStart HeightStart3 3*TextFontSize TextHeight];
ROIHeightValue.ValueDisplayFormat = '%d';
ROIHeightValue.Value = Camera.getImageHeight(); ROIHeightValue.FontWeight = 'bold'; ROIHeightValue.FontSize = TextFontSize;
ROIHeightValue.Limits = [0 Camera.getSensorHeightMax()]; ROIHeightValue.LowerLimitInclusive = 'on'; ROIHeightValue.UpperLimitInclusive = 'on';



%%% % Text "Avg. Intensity"
AvgIntensityLabel = uilabel(CameraPanel);
WidthStart = CommandWidth -10*TextHeight;
HeightStart =  CameraPanelHeight-2*TextHeight;

AvgIntensityLabel.Position=[WidthStart HeightStart 7*TextFontSize TextHeight];
AvgIntensityLabel.Text = 'Avg. Intensity'; AvgIntensityLabel.FontWeight = 'bold'; AvgIntensityLabel.FontSize = TextFontSize;


%%% Avg. Intensity (numeric edit field)

AvgIntensityValue = uieditfield(CameraPanel,'numeric');
HeightStart = HeightStart - 5*SpaceSize;
AvgIntensityValue.Position = [WidthStart HeightStart 6*TextFontSize TextHeight];
AvgIntensityValue.ValueDisplayFormat = '%d';
AvgIntensityValue.Value = 0; AvgIntensityValue.FontWeight = 'bold'; AvgIntensityValue.FontSize = TextFontSize;
% % AvgIntensityValue.Limits = [0 Camera.getSensorHeightMax()]; ROIHeightValue.LowerLimitInclusive = 'on'; ROIHeightValue.UpperLimitInclusive = 'on';






%%% % Text "Max. Intensity"
MaxIntensityLabel = uilabel(CameraPanel);
MaxIntensityLabel.FontColor = [0.6350 0.0780 0.1840];
HeightStart = HeightStart - 6*SpaceSize; 
MaxIntensityLabel.Position=[WidthStart HeightStart 7*TextFontSize TextHeight];
MaxIntensityLabel.Text = 'Max. Intensity'; MaxIntensityLabel.FontWeight = 'bold'; MaxIntensityLabel.FontSize = TextFontSize;


%%% Max. Intensity (numeric edit field)

MaxIntensityValue = uieditfield(CameraPanel,'numeric');
HeightStart = HeightStart - 5*SpaceSize;
MaxIntensityValue.Position = [WidthStart HeightStart 6*TextFontSize TextHeight];
MaxIntensityValue.ValueDisplayFormat = '%d';
MaxIntensityValue.Value = 0; MaxIntensityValue.FontWeight = 'bold'; MaxIntensityValue.FontSize = TextFontSize;




%%
LaserPanel = uipanel(Main); 
LaserPanel.Units='pixels';
LaserPanelHeight = 4*TextHeight;
PanelHeightStart = floor(0.65*ScreenHeigth)- CameraPanelHeight - LaserPanelHeight;
PanelWidthtStart = floor(0.702*ScreenWidth);
LaserPanel.Position=[PanelWidthtStart  PanelHeightStart ...
CommandWidth- SpaceSize  LaserPanelHeight];

LaserPanel.BorderType = 'line';
LaserPanel.BackgroundColor = [0 0.4470 0.7410];
% Title
LaserPanel.FontSize = TitleFontSize;
LaserPanel.Title = 'LASER'; LaserPanel.TitlePosition = 'centertop';

% Text ON/OFF 
LaserOnOffButton = uibutton(LaserPanel,'state');
LaserOnOffButton.Text = 'ON/OFF'; LaserOnOffButton.FontWeight = 'bold'; LaserOnOffButton.FontSize = TextFontSize;
HeightStart1 = LaserPanelHeight-2*TextHeight - 2*SpaceSize;
WidthStart = SpaceSize;
LaserOnOffButton.Position=[WidthStart HeightStart1 4.5*TextFontSize TextHeight]; 

%
HeightStart2 = HeightStart1 - 5*SpaceSize;
% Laser power level
% Text "Power"
PowerLabel = uilabel(LaserPanel);
PowerLabel.Position=[WidthStart HeightStart2 6*TextFontSize TextHeight];
PowerLabel.Text = 'Power(%)'; PowerLabel.FontWeight = 'bold'; PowerLabel.FontSize = TextFontSize;
PowerLabel.FontColor = [0.6350 0.0780 0.1840];
HeightStart3 = HeightStart2 - 5*SpaceSize;


%  Power level (numeric value)
PowerValue = uieditfield(LaserPanel,'numeric');
PowerValue.Position = [WidthStart HeightStart3  4.7*TextFontSize TextHeight];
PowerValue.ValueDisplayFormat = '%d';
PowerValue.Value = 5; PowerValue.FontWeight = 'bold'; PowerValue.FontSize = TextFontSize;
PowerValue.Limits = [0 Laser.maxPowerLevel]; PowerValue.LowerLimitInclusive = 'on'; PowerValue.UpperLimitInclusive = 'on';


% Text Wavelength
% 
WavelengthLabel = uilabel(LaserPanel);
WavelengthLabel.Text = 'Wavelength(nm)'; WavelengthLabel.FontWeight = 'bold'; WavelengthLabel.FontSize = TextFontSize;
HeightStart1 = LaserPanelHeight-2*TextHeight - 2*SpaceSize;
WidthStart = 6.5*TextFontSize ;
WavelengthLabel.Position=[WidthStart HeightStart1 8*TextFontSize TextHeight]; 

%  Wavelength value  (numeric value)
WavelengthValue = uieditfield(LaserPanel,'numeric');
HeightStart2 = HeightStart1 - 7*SpaceSize;
WidthStart = WidthStart + 5*SpaceSize;
WavelengthValue.Position = [WidthStart HeightStart2  4.7*TextFontSize TextHeight];
WavelengthValue.ValueDisplayFormat = '%d';
WavelengthValue.Value = Laser.defaultWaveLength; WavelengthValue.FontWeight = 'bold'; WavelengthValue.FontSize = TextFontSize;
WavelengthValue.Limits = [Laser.minWavelength Laser.maxWavelength]; WavelengthValue.LowerLimitInclusive = 'on'; 
WavelengthValue.UpperLimitInclusive = 'on';



% Text Bandwidth 
BandwidthLabel = uilabel(LaserPanel);
BandwidthLabel.Text = 'Bandwidth(nm)'; BandwidthLabel.FontWeight = 'bold'; BandwidthLabel.FontSize = TextFontSize;
HeightStart1 = LaserPanelHeight-2*TextHeight - 2*SpaceSize;
WidthStart = CommandWidth - 12.8*TextFontSize ;
BandwidthLabel.Position=[WidthStart HeightStart1 7.5*TextFontSize TextHeight]; 

%  Bandwidth value  (numeric value)
BandwidthValue = uieditfield(LaserPanel,'numeric');

HeightStart2 = HeightStart1 - 7*SpaceSize;
WidthStart = WidthStart + 5*SpaceSize;

BandwidthValue.Position = [WidthStart HeightStart2  4.7*TextFontSize TextHeight];
BandwidthValue.ValueDisplayFormat = '%d';
BandwidthValue.Value = Laser.defaultBandWidth; BandwidthValue.FontWeight = 'bold'; BandwidthValue.FontSize = TextFontSize;
BandwidthValue.Limits = [Laser.minBandWidth Laser.maxBandWidth]; BandwidthValue.LowerLimitInclusive = 'on'; 
BandwidthValue.UpperLimitInclusive = 'on';

%% DAC  Panel
DacPanel = uipanel(Main); 
DacPanel.Units='pixels';
DacPanelHeight = 3.8*TextHeight;
PanelHeightStart = floor(0.65*ScreenHeigth)- CameraPanelHeight - LaserPanelHeight - DacPanelHeight;
PanelWidthtStart = floor(0.702*ScreenWidth);
DacPanel.Position=[PanelWidthtStart  PanelHeightStart ...
CommandWidth- SpaceSize  DacPanelHeight];

DacPanel.BorderType = 'line';
DacPanel.BackgroundColor = [0.4940 0.1840 0.5560];
% Title
DacPanel.FontSize = TitleFontSize;
DacPanel.Title = 'DAC'; DacPanel.TitlePosition = 'centertop';

% Text ChannelX (this corresponds to channel # 0) 
ChannelXLabel = uilabel(DacPanel);
ChannelXLabel.Text = 'ChX(volt)'; ChannelXLabel.FontWeight = 'bold'; ChannelXLabel.FontSize = TextFontSize;
HeightStart1 = DacPanelHeight -2*TextHeight - 2*SpaceSize;
WidthStart = CommandWidth - 16*TextHeight;
ChannelXLabel.Position=[WidthStart HeightStart1 7.5*TextFontSize TextHeight]; 

%  ChannelX value  (numeric value)
ChannelXValue = uieditfield(DacPanel,'numeric');

WidthStart1 = CommandWidth - 12.6*TextHeight;
ChannelXValue.Position = [WidthStart1 HeightStart1  4*TextFontSize TextHeight];
ChannelXValue.ValueDisplayFormat = '%d';
ChannelXValue.Value = 0; ChannelXValue.FontWeight = 'bold'; ChannelXValue.FontSize = TextFontSize;
ChannelXValue.Limits = [Dq.minVoltChannelX  Dq.maxVoltChannelX]; ChannelXValue.LowerLimitInclusive = 'on'; 
ChannelXValue.UpperLimitInclusive = 'on';
ChannelXValue.ValueDisplayFormat = '%0.3f';

% Slider ChannelX (this corresponds to channel # 0) 
ChannelXSlider = uislider(DacPanel);
HeightStart2 = HeightStart1 - 3*SpaceSize;

ChannelXSlider.Position=[WidthStart HeightStart2  10*TextFontSize  3]; 
ChannelXSlider.Value = 0; %% The default value of the slider
ChannelXSlider.Limits = [Dq.minVoltChannelX  Dq.maxVoltChannelX]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Text ChannelY (this corresponds to channel # 1) 
ChannelYLabel = uilabel(DacPanel);
ChannelYLabel.Text = 'ChY(volt)'; ChannelYLabel.FontWeight = 'bold'; ChannelYLabel.FontSize = TextFontSize;
HeightStart1 = DacPanelHeight -2*TextHeight - 2*SpaceSize;
WidthStart = CommandWidth - 6.4*TextHeight;
ChannelYLabel.Position=[WidthStart HeightStart1 7.5*TextFontSize TextHeight]; 

%  ChannelY value  (numeric value)
ChannelYValue =  uieditfield(DacPanel,'numeric');

WidthStart1 = CommandWidth - 3*TextHeight;
ChannelYValue.Position = [WidthStart1 HeightStart1  4*TextFontSize TextHeight];
ChannelYValue.ValueDisplayFormat = '%d';
ChannelYValue.Value = 0; ChannelYValue.FontWeight = 'bold'; ChannelYValue.FontSize = TextFontSize;
ChannelYValue.Limits = [Dq.minVoltChannelY  Dq.maxVoltChannelY]; ChannelYValue.LowerLimitInclusive = 'on'; 
ChannelYValue.UpperLimitInclusive = 'on';
ChannelYValue.ValueDisplayFormat = '%0.3f';
% Slider ChannelY (this corresponds to channel # 0) 
ChannelYSlider = uislider(DacPanel);
HeightStart2 = HeightStart1 - 3*SpaceSize;

ChannelYSlider.Position=[WidthStart HeightStart2  10*TextFontSize  3]; 
ChannelYSlider.Value = 0; %% The default value of the slider
ChannelYSlider.Limits = [Dq.minVoltChannelY  Dq.maxVoltChannelY]; 


% DEFAULT  button
DacGoHomeButton = uibutton(DacPanel);
DacGoHomeButton.Text = 'DEFAULT'; DacGoHomeButton.FontWeight = 'bold'; DacGoHomeButton.FontSize = TextFontSize;
HeightStart = DacPanelHeight - 2*TextHeight - 8*SpaceSize;
WidthStart = CommandWidth - 9.7*TextHeight;
DacGoHomeButton.Position=[WidthStart HeightStart  5*TextFontSize TextHeight]; 
DacGoHomeButton.FontColor = [0.4660 0.6740 0.1880];

%%
%% Acquisition Panel
AcquisitionPanel = uipanel(Main); 
AcquisitionPanel.Units='pixels';
% % AcquisitionPanelHeight = 7*TextHeight;
AcquisitionPanelHeight = floor(0.65*ScreenHeigth)- CameraPanelHeight - LaserPanelHeight...
    - DacPanelHeight - SpaceSize;
PanelHeightStart = floor(0.65*ScreenHeigth)- CameraPanelHeight - LaserPanelHeight...
    - DacPanelHeight - AcquisitionPanelHeight;
PanelWidthtStart = floor(0.702*ScreenWidth);
AcquisitionPanel.Position=[PanelWidthtStart  PanelHeightStart ...
CommandWidth-SpaceSize  AcquisitionPanelHeight];

AcquisitionPanel.BorderType = 'line';
AcquisitionPanel.BackgroundColor = [0.3010 0.7450 0.9330];
% Title
AcquisitionPanel.FontSize = TitleFontSize;
AcquisitionPanel.Title = 'ACQUISITION'; AcquisitionPanel.TitlePosition = 'centertop';


% Scan pattern drop down menue
ScanPatternDropDown = uidropdown(AcquisitionPanel);
ScanPatternDropDown.Items = {'No pattern selected','Raster type','Snake motion type','Circular type','Spiral type', 'Circular(TIR)'};
ScanPatternDropDown.FontColor = 'blue';

WidthStart = CommandWidth - 5*TextHeight;
HeightStart = AcquisitionPanelHeight - 6.8*TextHeight;

ScanPatternDropDownWidth = 4.6*TextHeight;
ScanPatternDropDownHeight =  TextHeight;

ScanPatternDropDown.Position=[WidthStart  HeightStart ...
ScanPatternDropDownWidth  ScanPatternDropDownHeight];

% Text Scan pattern dropdown menue
textScanPatternDropDown = uilabel(AcquisitionPanel);

textScanPatternDropDown.Text = 'Select scan pattern'; 
textScanPatternDropDown.FontWeight = 'bold';
textScanPatternDropDown.FontSize = 14;

HeightStart1 = HeightStart + 5*SpaceSize;


textScanPatternDropDown.Position=[WidthStart+SpaceSize  HeightStart1 4.6*TextHeight TextHeight]; 
textScanPatternDropDown.FontColor = 'blue';

% Sleep time drop down menue
SleepTimeDropDown = uidropdown(AcquisitionPanel);
SleepTimeDropDown.Items = {'0.10', '0.20', '0.30', '0.40', '0.50', '1.00', '2.00', '5.00'};
SleepTimeDropDown.FontColor = 'blue';

WidthStart = CommandWidth - 9*TextHeight-SpaceSize;
HeightStart = AcquisitionPanelHeight - 6.8*TextHeight;

SleepTimeDropDownWidth = 4*TextHeight;
SleepTimeDropDownHeight =  TextHeight;

SleepTimeDropDown.Position=[WidthStart  HeightStart ...
SleepTimeDropDownWidth  SleepTimeDropDownHeight];


% Text SleepTimeDropDown menue
textSleepTimeDropDown = uilabel(AcquisitionPanel);
textSleepTimeDropDown.Text = 'Select sleep time'; 
textSleepTimeDropDown.FontWeight = 'bold';
textSleepTimeDropDown.FontSize = 14;
HeightStart1 = AcquisitionPanelHeight - 6.8*TextHeight + 5*SpaceSize;
WidthStart = CommandWidth - 9*TextHeight-SpaceSize;
textSleepTimeDropDown.Position=[WidthStart+SpaceSize  HeightStart1 4.6*TextHeight TextHeight]; 
textSleepTimeDropDown.FontColor = 'blue';

% Scan  button
ScanButton = uibutton(AcquisitionPanel);
ScanButton.Text = 'SCAN'; ScanButton.FontWeight = 'bold'; ScanButton.FontSize = TextFontSize;
HeightStart = AcquisitionPanelHeight - 6.8*TextHeight;
WidthStart  = CommandWidth - 12.4*TextHeight + SpaceSize;
ScanButton.Position=[WidthStart HeightStart  5*TextFontSize TextHeight]; 
ScanButton.FontColor = 'blue';

% ScanCounter (numeric edit field)
ScanCounter = uieditfield(AcquisitionPanel,'numeric');
HeightStart = HeightStart + 1.5*TextHeight;
ScanCounter.Position=[WidthStart+ TextFontSize  HeightStart  3*TextFontSize TextHeight]; 
ScanCounter.ValueDisplayFormat = '%3d';
ScanCounter.Value =  str2double(Data.ScanCounter); %% The initial value 
ScanCounter.FontWeight = 'bold'; ScanCounter.FontSize = TextFontSize;
ScanCounter.FontColor = 'blue';


% Text Counter
textCounter = uilabel(AcquisitionPanel);

textCounter.Text = 'COUNTERS'; 
textCounter.FontWeight = 'bold';
textCounter.FontSize = TextFontSize;

HeightStart = HeightStart + TextHeight;
WidthStart  = CommandWidth - 14*TextHeight - SpaceSize;

textCounter.Position=[WidthStart  HeightStart 6*TextFontSize TextHeight]; 

% Snapshot  button
SnapshotButton = uibutton(AcquisitionPanel);
SnapshotButton.Text = 'SNAPSHOT'; SnapshotButton.FontWeight = 'bold'; SnapshotButton.FontSize = TextFontSize;
HeightStart = AcquisitionPanelHeight - 6.8*TextHeight;
WidthStart  = CommandWidth - 16*TextHeight + SpaceSize;
SnapshotButton.Position=[WidthStart HeightStart  6*TextFontSize TextHeight]; 
SnapshotButton.FontColor = [0.4660 0.6740 0.1880];

% SnapCounter value (numeric edit field)
SnapCounter = uieditfield(AcquisitionPanel,'numeric');
HeightStart = HeightStart + 1.5*TextHeight;
SnapCounter.Position=[WidthStart+1.5*TextFontSize  HeightStart  3*TextFontSize TextHeight]; 
SnapCounter.ValueDisplayFormat = '%3d';
SnapCounter.Value = str2double(Data.SnapShotCounter); %% The initial value 
SnapCounter.FontWeight = 'bold'; SnapCounter.FontSize = TextFontSize;
SnapCounter.FontColor = [0.4660 0.6740 0.1880];






% Save folder path

SaveFolderDisplay = uieditfield(AcquisitionPanel);
WidthStart  = CommandWidth - 16*TextHeight + SpaceSize;
HeightStart = AcquisitionPanelHeight - 2.5*TextHeight;
SaveFolderLength = CommandWidth-2*SpaceSize-4*TextFontSize;
SaveFolderDisplay.Position = [WidthStart HeightStart SaveFolderLength TextHeight];
SaveFolderDisplay.Value = Data.FolderPath; SaveFolderDisplay.FontSize = TextFontSize;
SaveFolderDisplay.Editable = 'off'; 

% Save folder button

WidthStart = WidthStart+SaveFolderLength;
% Button "Choose folder"
SaveFolderButton = uibutton(AcquisitionPanel);
SaveFolderButton.Text = ''; 
SaveFolderButton.Icon = fullfile([pwd, '\headerAndFunctionsSaveData'], 'Folder.jpg');
SaveFolderButton.Position=[WidthStart HeightStart CommandWidth-SaveFolderLength-7*SpaceSize  TextHeight]; 




%% All actions are implemented here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Camera
set(CameraLiveButton,'ValueChangedFcn',@(src,event) CameraLive(Camera,CameraImage, CameraImageKspace, ...
    MaxIntensityValue,AvgIntensityValue, CameraLiveButton.Value));
set(ExposureValue,'ValueChangedFcn',@(src,event) SetCameraExposure(Camera,ExposureValue.Value));
set(ROIWidthValue,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage, CameraImageKspace));
set(ROIHeightValue,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage, CameraImageKspace));


% Laser
set(LaserOnOffButton,'ValueChangedFcn',@(src,event) LaserOnOff(Laser,LaserOnOffButton.Value));
set(PowerValue,'ValueChangedFcn',@(src,event) SetLaserPower(Laser, PowerValue.Value));
set(WavelengthValue,'ValueChangedFcn',@(src,event) SetLaserWavelength(Laser, WavelengthValue.Value));
set(BandwidthValue,'ValueChangedFcn',@(src,event) SetLaserBandwidth(Laser, BandwidthValue.Value));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Dac
set(ChannelXValue,'ValueChangedFcn',@(src,event) SetDacChXvolt(Dq, ChannelXSlider, ChannelXValue,  ChannelXValue.Value));
set(ChannelXSlider,'ValueChangedFcn',@(src,event) SetDacChXvolt(Dq, ChannelXSlider, ChannelXValue, ChannelXSlider.Value));
set(ChannelYValue,'ValueChangedFcn',@(src,event) SetDacChYvolt(Dq, ChannelYSlider, ChannelYValue,  ChannelYValue.Value));
set(ChannelYSlider,'ValueChangedFcn',@(src,event) SetDacChYvolt(Dq, ChannelYSlider, ChannelYValue, ChannelYSlider.Value));
set(DacGoHomeButton,'ButtonPushedFcn',@(DacGoHomeButton,event) SetDacDefault(Dq, ChannelXSlider, ChannelYSlider, ChannelXValue, ChannelYValue));


%%% Acquisition
% The snapbutton
set(SnapshotButton,'ButtonPushedFcn', @(SnapshotButton,event) getOneImage(Camera, Data, SnapCounter));
% The scan
set(ScanPatternDropDown,'ValueChangedFcn',@(ScanPatternDropDown, event) ChoseScanPattern(ScanPattern, ScanPatternDropDown));
set(ScanButton ,'ButtonPushedFcn', @(ScanButton,event) performScan(Camera, Rotator, ScanPattern, Dq, SleepTimeDropDown, Data, ScanCounter));
% Chose folder to save data
set(SaveFolderButton,'ButtonPushedFcn',@(src,event) ChooseSaveFolder(SaveFolderDisplay, Data, ScanCounter, SnapCounter));


%% Camera
%%% The Live Button
function CameraLive(Camera,CameraImage, CameraImageKspace, MaxIntensityValue,AvgIntensityValue,CameraLiveValue)
    if CameraLiveValue == 1
        Camera.IsLiveON = true;
        img = (Camera.getImageFrame())';
        CameraImage.XLim = [0,Camera.getImageWidth()]; CameraImage.YLim = [0,Camera.getImageHeight()];
        CameraImageKspace.XLim = [0,Camera.getImageWidth()]; CameraImageKspace.YLim = [0,Camera.getImageHeight()];

        h =  imagesc(CameraImage,img); colormap(CameraImage,gray);
        h2 = imagesc(CameraImageKspace, (log10(abs(fftshift(fft2(img)))))); 
        
        while( Camera.IsLiveON == true)
            
            img = (Camera.getImageFrame())';
            set(h,'CData', img);
            set(h2,'CData',log10(abs(fftshift(fft2(img)))));
            
            avg_intensity = floor(sum(sum(img))/(size(img,1)*size(img,2)));
            AvgIntensityValue.Value = double(avg_intensity);   %% Display the average intensity 
            MaxIntensityValue.Value = double((max(max(img)))); %% Display the maximum intensity
        end
        Camera.StopCapture();
        
    else
        Camera.IsLiveON = false;
    end
end

%%% The exposure time
function SetCameraExposure(Camera,ExposureTime)
    Camera.setExposureTime(ExposureTime);
end

%%% The camera ROI
function SetCameraROI(Camera, Width,Height,CameraImage, CameraImageKspace)
    
    Camera.setROI(Width, Height);
    % Update size of the display

    CameraImage.XLim = [0,Width]; CameraImage.YLim = [0,Height];
    CameraImageKspace.XLim = [0,Width]; CameraImageKspace.YLim = [0,Height];
end


%%
% Laser turn ON and turn OFF 
function LaserOnOff(Laser, OnOffValue)
    if (OnOffValue == 1)
        Laser.turnONdevice();
    end
    if(OnOffValue == 0)
        Laser.turnOFFdevice();
    end
end

% Set the laser Power
%%% The Laser Power
function SetLaserPower(Laser,powerLevel)
    Laser.setPowerLevel(powerLevel);
end

% Set the laser wavelength
function SetLaserWavelength(Laser, lambda)
    Laser.setWavelength(lambda);
end


function SetLaserBandwidth(Laser, spectralBandwidth)
    Laser.setBandWidth(spectralBandwidth);
end


%% Dac
%%% set the channel X voltage of Dac
function SetDacChXvolt(Dq, ChannelXSlider, ChannelXValue, voltage)
    Dq.putVoltageChX(voltage);
    ChannelXSlider.Value = voltage;
    ChannelXValue.Value = voltage;
end

 %%% set the channel Y voltage of Dac
function SetDacChYvolt(Dq, ChannelYSlider, ChannelYValue, voltage)
    Dq.putVoltageChY(voltage);
    ChannelYSlider.Value = voltage;
    ChannelYValue.Value = voltage;
end

%%% set the Dac to default (both channel voltage is set to 0 volt)
function SetDacDefault(Dq, ChannelXSlider, ChannelYSlider, ChannelXValue, ChannelYValue)
        Dq.goHome();
        ChannelXSlider.Value = 0;
        ChannelXValue.Value =  0;
        ChannelYSlider.Value = 0;
        ChannelYValue.Value =  0;
end


%% Aquistion
%%% The snapshot button
function getOneImage(Camera, Data, SnapCounter)
    %%% Check if the camera is live, if live is on turn it off before the image snap
    if(Camera.IsLiveON == true)
     Camera.IsLiveON = false;
    end
   
    %%% Update the Snap Counter value
    Data.IncrementCounter('SnapShotCounter');
    
    FileName = [Data.FolderPath, Data.SnapFileNameFirstPart, ...
        datestr(now,'yyyymmdd'),'_', Data.SnapShotCounter];
    
    img = (Camera.getImageFrame())';
    save( fullfile(FileName),'img');
    %save FileName img_snap_one;
    disp('Snap is taken');
    %%% Update the counter display
    SnapCounter.Value = str2double(Data.SnapShotCounter);
    Camera.IsLiveON = true;  % Turn on the camera live again
end

%%% The selection of scan pattern

function ChoseScanPattern(ScanPattern, ScanPatternDropDown)
switch(ScanPatternDropDown.Value)
case 'Raster type'
   ScanPattern.rasterScanPattern();
case 'Snake motion type'
   ScanPattern.snakeMovemnetScanPattern();
case 'Circular type'
   ScanPattern.circularScanPattern();
case 'Spiral type'
   ScanPattern.spiralScanPattern();
case 'Circular(TIR)'
   ScanPattern.circularTIR();  
   
   
otherwise
   fprintf('Invalid scan pattern\n' );
end
end



%%% The scan function 
function performScan(Camera, Rotator, ScanPattern, Dq, SleepTimeDropDown, Data, ScanCounter)

 if(Camera.IsLiveON == true)
     Camera.IsLiveON = false;
 end

disp('Scaning started.....');
    tic  %%% to calculate the timing for the scaning 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Get ready the Dac
	Dq.goHome();  % Set the both channel to zero voltage
	voltage_ch0_scan = ScanPattern.voltage_ch0_scan;
	voltage_ch1_scan = ScanPattern.voltage_ch1_scan;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%%% The Rotator
phi = ScanPattern.getPhiValue();
phiStep = phi(2) - phi(1);
Rotator.goHome();
pause(2);    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%% to alocate the momery
     sz_stack = size(voltage_ch0_scan, 1);
     temp_data = Camera.getImageFrame();
     scan_data = repmat(temp_data, [1, 1, sz_stack]);
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Calculate the pause time
     sleepTime = str2double(SleepTimeDropDown.Value);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = 1:size(voltage_ch0_scan,1)
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% set the channel voltage
        %%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 
        Dq.putVoltage(voltage_ch0_scan(ii), voltage_ch1_scan(ii));
        
        Rotator.rotationRelative(phiStep);
        pause(sleepTime); % sleep time to settle the galvano mirrors
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        scan_data(:,:,ii) = Camera.getImageFrame(); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    timeElapsed = toc  % to display the total time elapsed 
    
    
 %%% Update the Snap Counter value
    Data.IncrementCounter('ScanCounter');
    FileName = [Data.FolderPath, Data.ScanFileNameFirstPart, ...
        datestr(now,'yyyymmdd'),'_', Data.ScanCounter];
    
    save( fullfile(FileName),'scan_data')
    clear scan_data; 
    Dq.goHome();  % Set the both channel to zero voltage
    
    ScanCounter.Value = str2double(Data.ScanCounter);
    Camera.IsLiveON = true;  % Camera live is on
    disp('Scan is finished.....');
end       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Chose the folder where the data will be stored

function ChooseSaveFolder(SaveFolder, Data, ScanCounter, SnapCounter)
    SaveFolder.Value = uigetdir(SaveFolder.Value);
    Data.RootFolderPath = strcat(SaveFolder.Value, '\');
    Data.SetFolderPath();
    fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'RootFolderPath.txt'),'w');
    fprintf(fileID,'%s', Data.RootFolderPath);
    fclose(fileID);
    SaveFolder.Value = Data.FolderPath;
    %%%% Once diffierent directory is chosen to store data 
    %%% The counter values should be set to zero
    Data.ResetCounter('ScanCounter');
    Data.ResetCounter('SnapShotCounter');
    SnapCounter.Value = 0;
    ScanCounter.Value = 0;
    
end