
%%% Matlab GUI for driving the Tomographic diffractive microscopy(TDM)

%%Clear all
close all
clear all


%% Connect to the devices
%%%Connect the AndorZyla camera
% % Camera = DevicePack.camAndorZyla; 
% % Camera.setROI(1392, 1040);

%%% Connect the photon focus camera
Camera = DevicePack.camPhotonFocus;


%%% Connect the pco.panda camera
% % Camera = DevicePack.camPcoPanda;
% % Camera.setROI(1216, 1216);

%%% 
% %  Camera = DevicePack.CameraPcoPanda;
% %  Camera.setROI(1024, 1024);
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
CameraPanel.BackgroundColor = DarkGray;
% Title
CameraPanel.FontSize = TitleFontSize;
CameraPanel.Title = 'CAMERA'; CameraPanel.TitlePosition = 'centertop';

HeightStart = CameraPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = SpaceSize;


% Live
CameraLiveButton = uibutton(CameraPanel,'state');
CameraLiveButton.Text = 'LIVE'; CameraLiveButton.FontWeight = 'bold'; CameraLiveButton.FontSize = TextFontSize;
CameraLiveButton.Position=[WidthStart HeightStart 4.5*TextFontSize TextHeight]; 







%% All actions are implemented here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(CameraLiveButton,'ValueChangedFcn',@(src,event) CameraLive(Camera,CameraImage, CameraImageKspace,CameraLiveButton.Value));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
function CameraLive(Camera,CameraImage, CameraImageKspace,CameraLiveValue)
   
    if CameraLiveValue == 1
        Camera.IsLiveON = true;
        img = (Camera.getImageFrame())';
        h =  imagesc(CameraImage,img); colormap(CameraImage,gray);
        h2 = imagesc(CameraImageKspace, (log10(abs(fftshift(fft2(img)))))); 
        
        while Camera.IsLiveON == true
            img = (Camera.getImageFrame())';
            set(h,'CData', img);
            set(h2,'CData',log10(abs(fftshift(fft2(img)))));
            
        end
        if(Camera == DevicePack.CameraPcoPanda)
            Camera.StopCapture();
        end
    else
        Camera.IsLiveON = false;
    end
end

