%% Connect to the devices
% Connect the camera
Camera = BSICam();
% Connect the piezo stage
Piezo = E545();                                       % A éditer
% Connect Diffuser
Diffuser = StandaRotation();
% Connect Lens
Lens = Optotune();

%% Initialisation, get some useful values from the devices. Need to be properties in the new classes if any device is changed
% Camera
SensorSize = max(Camera.SensorWidth,Camera.SensorHeight);

% Piezo 3 axes
PiezoXYRange = [max(Piezo.XRange(1), Piezo.YRange(1)) , min(Piezo.XRange(2), Piezo.YRange(2))];
PiezoZRange = Piezo.ZRange;             
PiezoMaxVelocity = Piezo.MaxVelocity;   %Array of 3 values, for X Y Z

% Accordable Lens
LensMinFocal = Lens.MinFocalPower;
LensMaxFocal = Lens.MaxFocalPower;

%% Size of the computer screen. The programm assumes a 16:9 ratio
ScreenWidth = 1680;
ScreenHeigth = floor(ScreenWidth*9/16);
% Width of the command panel, on the left side
CommandWidth = ScreenWidth-ScreenHeigth;
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
% Background color gray to limit brightness
Main.Color = [0, 0, 0];
% Window size equal to screen resolution
Main.Units = 'pixels';
% Fill the screen
Main.Position = [0 0 ScreenWidth ScreenHeigth];                          
Main.Resize = 'off';

%% Create the area to display image
% Dummy Image
Image = zeros(SensorSize,SensorSize);                               % Consider a full-size image from the camera

CameraImage = uiaxes(Main);
% Position as [left bottom witdh heigth]. Here, we put the image on the right
CameraImage.Position = [CommandWidth 0 ScreenHeigth ScreenHeigth];           
% Makes a full square around the image
CameraImage.Box='on';
% Make sure x and y are same aspect ratio
CameraImage.DataAspectRatioMode='manual';
CameraImage.DataAspectRatio = [1 1 1];
% Set manual X and Y limits
CameraImage.XLimMode = 'manual'; CameraImage.YLimMode = 'manual';
CameraImage.XLim = [0,SensorSize]; CameraImage.YLim = [0,SensorSize];
% Display image the same way as ImageJ
CameraImage.XDir = 'normal'; CameraImage.YDir = 'reverse';
CameraImage.XAxisLocation = 'top'; CameraImage.YAxisLocation = 'left';
% Remove tick labels
CameraImage.XTick = []; CameraImage.YTick = [];
CameraImage.XTickLabel = []; CameraImage.YTickLabel = [];
% Display image in black and white
imagesc(CameraImage,Image); colormap(CameraImage,gray);
% Keep settings for next image
CameraImage.NextPlot='replacechildren';

%% Command Panel
% Matlab's origin is on the bottom left corner.
% Position as [left bottom witdh heigth].

%% XY Piezo control panel
XYPiezoPanel = uipanel(Main);
XYPiezoPanel.Units='pixels';
PiezoPanelHeigth = 10.5*TextHeight;
PanelHeightStart = ScreenHeigth-SpaceSize-PiezoPanelHeigth;
XYPiezoPanelWidth = 0.62*CommandWidth - SpaceSize;
XYPiezoPanel.Position=[SpaceSize PanelHeightStart XYPiezoPanelWidth PiezoPanelHeigth];
XYPiezoPanel.BorderType = 'line';
XYPiezoPanel.BackgroundColor = DarkGray;
% Title
XYPiezoPanel.Title = 'XY POSITION'; XYPiezoPanel.TitlePosition = 'centertop'; XYPiezoPanel.FontSize = TitleFontSize;

HeightStart = PiezoPanelHeigth-2*TextHeight-3*SpaceSize;    % Incremental variable to put boxes one under the others on a column
WidthStart = SpaceSize;                                     % Incremental variable to put boxes one aside the others on a line

%%Current position
% Text "Current Position"
CurrentXYLabel = uilabel(XYPiezoPanel);
CurrentXYLabel.Text = 'Current position:'; CurrentXYLabel.FontWeight = 'bold'; CurrentXYLabel.FontSize = TextFontSize;
CurrentXYWidth = 18*TextFontSize/2; %The width of one letter is about half of the TextFontSize
CurrentXYLabel.Position=[SpaceSize HeightStart CurrentXYWidth TextHeight]; 
WidthStart = WidthStart+CurrentXYWidth+SpaceSize;

% Text "X="
CurrentXLabel = uilabel(XYPiezoPanel);
CurrentXLabel.Position = [WidthStart HeightStart 2*TextFontSize TextHeight];
CurrentXLabel.Text = 'X='; CurrentXLabel.FontWeight = 'bold'; CurrentXLabel.FontSize = TextFontSize;
WidthStart = WidthStart+1.5*TextFontSize;
% Position X
XPosition = uieditfield(XYPiezoPanel,'numeric');
XPosition.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
XPosition.ValueDisplayFormat = '%3.3f';
XPosition.Value = 100; XPosition.FontWeight = 'bold'; XPosition.FontSize = TextFontSize;
XPosition.Editable = 'off'; XPosition.Enable = 'off';
WidthStart = WidthStart+5*TextFontSize+2*SpaceSize;
% Read current position for initialisation
XPosition.Value = Piezo.GetPosition('X');

% Text "Y="
CurrentYLabel = uilabel(XYPiezoPanel);
CurrentYLabel.Position=[WidthStart HeightStart 2*TextFontSize TextHeight];
CurrentYLabel.Text = 'Y='; CurrentYLabel.FontWeight = 'bold'; CurrentYLabel.FontSize = TextFontSize;
WidthStart = WidthStart+1.5*TextFontSize;
% Position Y
YPosition = uieditfield(XYPiezoPanel,'numeric');
YPosition.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
YPosition.ValueDisplayFormat = '%3.3f';
YPosition.Value = 100; YPosition.FontWeight = 'bold'; YPosition.FontSize = TextFontSize;
YPosition.Editable = 'off'; YPosition.Enable = 'off';
% Read current position for initialisation
YPosition.Value = Piezo.GetPosition('Y');


%%Joystick XY
HeightStart2 = HeightStart-3*TextHeight-SpaceSize;   % Incremental variable to put boxes one under the others on a column
WidthStart = SpaceSize;                              % Incremental variable to put boxes one aside the others on a line

% Step size
% Text "Step Size"
StepXYLabel = uilabel(XYPiezoPanel);
StepXYLabel.Position=[WidthStart HeightStart2 7*TextFontSize TextHeight];
StepXYLabel.Text = 'Step Size (µm)'; StepXYLabel.FontWeight = 'bold'; StepXYLabel.FontSize = TextFontSize;
WidthStart2 = WidthStart+7*TextFontSize;
% Step Size Value
StepXYValue = uieditfield(XYPiezoPanel,'numeric');
StepXYValue.Position = [WidthStart2 HeightStart2 5*TextFontSize TextHeight];
StepXYValue.ValueDisplayFormat = '%3.3f';
StepXYValue.Value = 10; StepXYValue.FontWeight = 'bold'; StepXYValue.FontSize = TextFontSize;
StepXYValue.Limits = PiezoXYRange; StepXYValue.LowerLimitInclusive = 'on'; StepXYValue.UpperLimitInclusive = 'on';
% StepValue will be read on each motion.

% Velocity
HeightStart2 = HeightStart2-TextHeight-SpaceSize;
% Text "Velocity"
VelocityXYLabel = uilabel(XYPiezoPanel);
VelocityXYLabel.Position=[WidthStart HeightStart2 7*TextFontSize TextHeight];
VelocityXYLabel.Text = 'Velocity (µm/s)'; VelocityXYLabel.FontWeight = 'bold'; VelocityXYLabel.FontSize = TextFontSize;
% Velocity Value
VelocityXYValue = uieditfield(XYPiezoPanel,'numeric');
VelocityXYValue.Position = [WidthStart2 HeightStart2 5*TextFontSize TextHeight];
VelocityXYValue.ValueDisplayFormat = '%3.3f';
VelocityXYValue.Value = min(Piezo.Velocity(1),Piezo.Velocity(2)); VelocityXYValue.FontWeight = 'bold'; VelocityXYValue.FontSize = TextFontSize;
VelocityXYValue.Limits = [0 min(Piezo.MaxVelocity(1),Piezo.MaxVelocity(2))]; VelocityXYValue.LowerLimitInclusive = 'on'; VelocityXYValue.UpperLimitInclusive = 'on';


% 4 buttons
ButtonSize = 2*TextHeight;
HeightStart = HeightStart-ButtonSize-2*SpaceSize;
WidthStart = SpaceSize+0.53*XYPiezoPanelWidth; 
% png image of an arrow
[arrowpng,~]=imread('Arrow.png');

% Up button
BouttonXY_Up = uibutton(XYPiezoPanel);
BouttonXY_Up.Position = [WidthStart+ButtonSize HeightStart ButtonSize ButtonSize];
BouttonXY_Up.Text = '';BouttonXY_Up.Icon = arrowpng;

% Left button
BouttonXY_Left = uibutton(XYPiezoPanel);
BouttonXY_Left.Position = [WidthStart HeightStart-ButtonSize ButtonSize ButtonSize];
BouttonXY_Left.Text = '';BouttonXY_Left.Icon = imrotate(arrowpng,90);

% Right button
BouttonXY_Right = uibutton(XYPiezoPanel);
BouttonXY_Right.Position = [WidthStart+2*ButtonSize HeightStart-ButtonSize ButtonSize ButtonSize];
BouttonXY_Right.Text = ''; BouttonXY_Right.Icon = imrotate(arrowpng,270);

% Down button
BouttonXY_Down = uibutton(XYPiezoPanel);
BouttonXY_Down.Position = [WidthStart+ButtonSize HeightStart-2*ButtonSize ButtonSize ButtonSize];
BouttonXY_Down.Text = ''; BouttonXY_Down.Icon = imrotate(arrowpng,180);

HeightStart = HeightStart-2*ButtonSize-TextHeight-2*SpaceSize;   % Incremental variable to put boxes one under the others on a column
WidthStart = SpaceSize;                              % Incremental variable to put boxes one aside the others on a line


%%Goto
HomeXYButton = uibutton(XYPiezoPanel);
HomeXYButton.Text = 'HOME'; HomeXYButton.FontWeight = 'bold'; HomeXYButton.FontSize = TextFontSize;
HomeXYButton.Position=[SpaceSize HeightStart CurrentXYWidth/2-SpaceSize TextHeight];
% Button "GoTo"
GoToXYButton = uibutton(XYPiezoPanel);
GoToXYButton.Text = 'GO TO'; GoToXYButton.FontWeight = 'bold'; GoToXYButton.FontSize = TextFontSize;
GoToXYButton.Position=[SpaceSize+CurrentXYWidth/2 HeightStart CurrentXYWidth/2-SpaceSize TextHeight]; 
WidthStart = WidthStart+CurrentXYWidth+SpaceSize;


% Text "X="
GoToXLabel = uilabel(XYPiezoPanel);
GoToXLabel.Position = [WidthStart HeightStart 2*TextFontSize TextHeight];
GoToXLabel.Text = 'X='; GoToXLabel.FontWeight = 'bold'; GoToXLabel.FontSize = TextFontSize;
WidthStart = WidthStart+1.5*TextFontSize;
% Position X
GoToXPosition = uieditfield(XYPiezoPanel,'numeric');
GoToXPosition.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
GoToXPosition.ValueDisplayFormat = '%3.3f';
GoToXPosition.Value = 100; GoToXPosition.FontWeight = 'bold'; GoToXPosition.FontSize = TextFontSize;
GoToXPosition.Limits = PiezoXYRange; GoToXPosition.LowerLimitInclusive = 'on'; GoToXPosition.UpperLimitInclusive = 'on';
WidthStart = WidthStart+5*TextFontSize+2*SpaceSize;

% Text "Y="
GoToYLabel = uilabel(XYPiezoPanel);
GoToYLabel.Position=[WidthStart HeightStart 2*TextFontSize TextHeight];
GoToYLabel.Text = 'Y='; GoToYLabel.FontWeight = 'bold'; GoToYLabel.FontSize = TextFontSize;
WidthStart = WidthStart+1.5*TextFontSize;
% Position Y
GoToYPosition = uieditfield(XYPiezoPanel,'numeric');
GoToYPosition.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
GoToYPosition.ValueDisplayFormat = '%3.3f';
GoToYPosition.Value = 100; GoToYPosition.FontWeight = 'bold'; GoToYPosition.FontSize = TextFontSize;
GoToYPosition.Limits = PiezoXYRange; GoToYPosition.LowerLimitInclusive = 'on'; GoToYPosition.UpperLimitInclusive = 'on';


%% Z Piezo control panel
ZPiezoPanel = uipanel(Main);
ZPiezoPanel.Units='pixels';
ZPiezoPanelWidth = CommandWidth - XYPiezoPanelWidth - 2*SpaceSize;
ZPiezoPanel.Position=[SpaceSize+XYPiezoPanelWidth PanelHeightStart ZPiezoPanelWidth PiezoPanelHeigth];
ZPiezoPanel.BorderType = 'line';
ZPiezoPanel.BackgroundColor = DarkGray;
% Title
ZPiezoPanel.FontSize = TitleFontSize;
ZPiezoPanel.Title = 'Z POSITION'; ZPiezoPanel.TitlePosition = 'centertop';

HeightStart = PiezoPanelHeigth-2*TextHeight-3*SpaceSize;    % Incremental variable to put boxes one under the others on a column

% Text "Current Position"
CurrentZLabel = uilabel(ZPiezoPanel);
CurrentZLabel.Text = 'Current (µm):'; CurrentZLabel.FontWeight = 'bold'; CurrentZLabel.FontSize = TextFontSize;
CurrentZWidth = ZPiezoPanelWidth/2;
CurrentZLabel.Position=[SpaceSize HeightStart CurrentZWidth TextHeight]; 
WidthStart = SpaceSize+CurrentZWidth+SpaceSize; 
% Text "Z="
CurrentZLabel = uilabel(ZPiezoPanel);
CurrentZLabel.Position = [WidthStart HeightStart 2*TextFontSize TextHeight];
CurrentZLabel.Text = 'Z='; CurrentZLabel.FontWeight = 'bold'; CurrentZLabel.FontSize = TextFontSize;
WidthStart = WidthStart+1.5*TextFontSize;
% Position Z
ZPosition = uieditfield(ZPiezoPanel,'numeric');
ZPosition.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
ZPosition.ValueDisplayFormat = '%3.3f';
ZPosition.Value = 100; ZPosition.FontWeight = 'bold'; ZPosition.FontSize = TextFontSize;
ZPosition.Editable = 'off'; ZPosition.Enable = 'off';
% Read current position for initialisation
XPosition.Value = Piezo.GetPosition('Z');

%%Joystick Z
HeightStart2 = HeightStart-3*TextHeight-SpaceSize;   % Incremental variable to put boxes one under the others on a column
WidthStart = SpaceSize;                              % Incremental variable to put boxes one aside the others on a line

% Step size
% Text "Step Size"
StepZLabel = uilabel(ZPiezoPanel);
StepZLabel.Position=[WidthStart HeightStart2 5*TextFontSize TextHeight];
StepZLabel.Text = 'Step (µm)'; StepZLabel.FontWeight = 'bold'; StepZLabel.FontSize = TextFontSize;
WidthStart2 = WidthStart+5*TextFontSize;
% Step Size Value
StepZValue = uieditfield(ZPiezoPanel,'numeric');
StepZValue.Position = [WidthStart2 HeightStart2 5*TextFontSize TextHeight];
StepZValue.ValueDisplayFormat = '%3.3f';
StepZValue.Value = 10; StepZValue.FontWeight = 'bold'; StepZValue.FontSize = TextFontSize;
StepZValue.Limits = PiezoZRange; StepZValue.LowerLimitInclusive = 'on'; StepZValue.UpperLimitInclusive = 'on';

% Velocity
HeightStart2 = HeightStart2-TextHeight-SpaceSize;
% Text "Velocity"
VelocityZLabel = uilabel(ZPiezoPanel);
VelocityZLabel.Position=[WidthStart HeightStart2 5*TextFontSize TextHeight];
VelocityZLabel.Text = 'Vel. (µm/s)'; VelocityZLabel.FontWeight = 'bold'; VelocityZLabel.FontSize = TextFontSize;
% Step Size Value
VelocityZValue = uieditfield(ZPiezoPanel,'numeric');
VelocityZValue.Position = [WidthStart2 HeightStart2 5*TextFontSize TextHeight];
VelocityZValue.ValueDisplayFormat = '%3.3f';
VelocityZValue.Value = Piezo.Velocity(3); VelocityZValue.FontWeight = 'bold'; VelocityZValue.FontSize = TextFontSize;
VelocityZValue.Limits = [0 PiezoMaxVelocity(3)]; VelocityZValue.LowerLimitInclusive = 'on'; VelocityZValue.UpperLimitInclusive = 'on';

HeightStart = HeightStart-ButtonSize-2*SpaceSize;
WidthStart = SpaceSize+0.48*ZPiezoPanelWidth; 

% Up button
BouttonZ_Up = uibutton(ZPiezoPanel);
BouttonZ_Up.Position = [WidthStart+ButtonSize HeightStart ButtonSize ButtonSize];
BouttonZ_Up.Text = '';BouttonZ_Up.Icon = arrowpng;

% Down button
BouttonZ_Down = uibutton(ZPiezoPanel);
BouttonZ_Down.Position = [WidthStart+ButtonSize HeightStart-2*ButtonSize ButtonSize ButtonSize];
BouttonZ_Down.Text = ''; BouttonZ_Down.Icon = imrotate(arrowpng,180);

HeightStart = HeightStart-2*ButtonSize-TextHeight-2*SpaceSize;   % Incremental variable to put boxes one under the others on a column
WidthStart = SpaceSize;                                          % Incremental variable to put boxes one aside the others on a line

%%Goto
HomeZButton = uibutton(ZPiezoPanel);
HomeZButton.Text = 'HOME'; HomeZButton.FontWeight = 'bold'; HomeZButton.FontSize = TextFontSize;
HomeZButton.Position=[SpaceSize HeightStart CurrentZWidth/2-SpaceSize TextHeight]; 
% Button "GoTo"
GoToZButton = uibutton(ZPiezoPanel);
GoToZButton.Text = 'GOTO'; GoToZButton.FontWeight = 'bold'; GoToZButton.FontSize = TextFontSize;
GoToZButton.Position=[SpaceSize+CurrentZWidth/2 HeightStart CurrentZWidth/2-SpaceSize TextHeight]; 
WidthStart = WidthStart+CurrentZWidth;

% Text "Z="
GoToZLabel = uilabel(ZPiezoPanel);
GoToZLabel.Position = [WidthStart HeightStart 2*TextFontSize TextHeight];
GoToZLabel.Text = 'Z='; GoToZLabel.FontWeight = 'bold'; GoToZLabel.FontSize = TextFontSize;
WidthStart = WidthStart+1.5*TextFontSize+SpaceSize;
% Position Z
GoToZPosition = uieditfield(ZPiezoPanel,'numeric');
GoToZPosition.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
GoToZPosition.ValueDisplayFormat = '%3.3f';
GoToZPosition.Value = 100; GoToZPosition.FontWeight = 'bold'; GoToZPosition.FontSize = TextFontSize;
GoToZPosition.Limits = [0 200]; GoToZPosition.LowerLimitInclusive = 'on'; GoToZPosition.UpperLimitInclusive = 'on';


%% Diffuser control panel
DiffuserPanel = uipanel(Main);
DiffuserPanel.Units='pixels';
DiffuserPanelHeight = 4*TextHeight;
DiffuserPanelWidth = (CommandWidth-2*SpaceSize)*0.44;
PanelHeightStart = PanelHeightStart-SpaceSize-DiffuserPanelHeight;
DiffuserPanel.Position=[SpaceSize PanelHeightStart DiffuserPanelWidth DiffuserPanelHeight];
DiffuserPanel.BorderType = 'line';
DiffuserPanel.BackgroundColor = DarkGray;
% Title
DiffuserPanel.FontSize = TitleFontSize;
DiffuserPanel.Title = 'DIFFUSER'; DiffuserPanel.TitlePosition = 'centertop';

HeightStart = DiffuserPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = SpaceSize;

% Step size
% Text "Step Size"
DiffuserStepLabel = uilabel(DiffuserPanel);
DiffuserStepLabel.Position=[WidthStart HeightStart 6*TextFontSize TextHeight];
DiffuserStepLabel.Text = 'Step Size (°)'; DiffuserStepLabel.FontWeight = 'bold'; DiffuserStepLabel.FontSize = TextFontSize;
WidthStart2 = WidthStart+6*TextFontSize;
% Step Size Value
DiffuserStepValue = uieditfield(DiffuserPanel,'numeric');
DiffuserStepValue.Position = [WidthStart2 HeightStart 5*TextFontSize TextHeight];
DiffuserStepValue.ValueDisplayFormat = '%3.3f';
DiffuserStepValue.Value = 100; DiffuserStepValue.FontWeight = 'bold'; DiffuserStepValue.FontSize = TextFontSize;
DiffuserStepValue.Limits = [-360 360]; DiffuserStepValue.LowerLimitInclusive = 'on'; DiffuserStepValue.UpperLimitInclusive = 'on';
WidthStart3 = WidthStart2+5*TextFontSize+2*SpaceSize;
% Button "Step"
DiffuserStepButton = uibutton(DiffuserPanel);
DiffuserStepButton.Text = 'STEP'; DiffuserStepButton.FontWeight = 'bold'; DiffuserStepButton.FontSize = TextFontSize;
DiffuserStepButton.Position=[WidthStart3 HeightStart 5*TextFontSize TextHeight]; 
HeightStart = HeightStart-TextHeight-SpaceSize;

% Velocity
% Text "Velocity"
DiffuserVelocityLabel = uilabel(DiffuserPanel);
DiffuserVelocityLabel.Position=[WidthStart HeightStart 5*TextFontSize TextHeight];
DiffuserVelocityLabel.Text = 'Velocity'; DiffuserVelocityLabel.FontWeight = 'bold'; DiffuserVelocityLabel.FontSize = TextFontSize;
% Velocity Value
DiffuserVelocityValue = uieditfield(DiffuserPanel,'numeric');
DiffuserVelocityValue.Position = [WidthStart2 HeightStart 5*TextFontSize TextHeight];
DiffuserVelocityValue.ValueDisplayFormat = '%f';
DiffuserVelocityValue.Value = 1000; DiffuserVelocityValue.FontWeight = 'bold'; DiffuserVelocityValue.FontSize = TextFontSize;
DiffuserVelocityValue.Limits = [0 50000]; DiffuserVelocityValue.LowerLimitInclusive = 'on'; VelocityZValue.UpperLimitInclusive = 'on';
DiffuserSetVelocity(Diffuser,1000)

% Button "Rotate"
DiffuserRotateButton = uibutton(DiffuserPanel,'state');
DiffuserRotateButton.Text = 'ROTATE'; DiffuserRotateButton.FontWeight = 'bold'; DiffuserRotateButton.FontSize = TextFontSize;
DiffuserRotateButton.Position=[WidthStart3 HeightStart 5*TextFontSize TextHeight]; 


%% Lens control panel
LensPanel = uipanel(Main);
LensPanel.Units='pixels';
LensPanelWidth = CommandWidth-2*SpaceSize-DiffuserPanelWidth;
LensPanel.Position=[SpaceSize+DiffuserPanelWidth PanelHeightStart LensPanelWidth DiffuserPanelHeight];
LensPanel.BorderType = 'line';
LensPanel.BackgroundColor = DarkGray;
% Title
LensPanel.FontSize = TitleFontSize;
LensPanel.Title = 'LENS'; LensPanel.TitlePosition = 'centertop';

HeightStart = DiffuserPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = SpaceSize;

% Lens Mode
% Text "Lens Mode"
LensModeLabel = uilabel(LensPanel);
LensModeLabel.Position=[WidthStart HeightStart 3*TextFontSize TextHeight];
LensModeLabel.Text = 'Mode'; LensModeLabel.FontWeight = 'bold'; LensModeLabel.FontSize = TextFontSize;
WidthStart = WidthStart+3*TextFontSize;
% Lens Mode Drop Down
LensMode = uidropdown(LensPanel);
LensMode.Position = [WidthStart HeightStart 8*TextFontSize TextHeight];
LensMode.Items = {'Analog', 'Current', 'Focal Power', 'Sinusoidal', 'Triangular', 'Rectangular'};
% Initialise in Focal Power Mode, with 0 Focal Power
LensMode.Value = 'Focal Power'; Lens.SetModeFocalPower(); Lens.SetFocalPower(0);
LensMode.FontWeight = 'bold'; LensMode.FontSize = TextFontSize;
WidthStart = WidthStart+8*TextFontSize+2*SpaceSize;


% Command to send to the Lens
% Text "Value"
LensValueLabel = uilabel(LensPanel);
LensValueLabel.Position=[WidthStart HeightStart 3*TextFontSize TextHeight];
LensValueLabel.Text = 'Value'; LensValueLabel.FontWeight = 'bold'; LensValueLabel.FontSize = TextFontSize;
WidthStart = WidthStart+3*TextFontSize;
% Value
LensValue = uieditfield(LensPanel,'numeric');
LensValue.Position = [WidthStart HeightStart 3*TextFontSize TextHeight];
LensValue.ValueDisplayFormat = '%1.2f';
LensValue.Value = 0; LensValue.FontWeight = 'bold'; LensValue.FontSize = TextFontSize;
LensValue.Limits = [LensMinFocal LensMaxFocal]; LensValue.LowerLimitInclusive = 'on'; LensValue.UpperLimitInclusive = 'on';
WidthStart = WidthStart+3*TextFontSize;
% Unit
LensUnit = uieditfield(LensPanel);
LensUnit.Position = [WidthStart HeightStart 5*TextFontSize TextHeight];
LensUnit.Value = 'Dioptrie'; LensUnit.FontWeight = 'bold'; LensUnit.FontSize = TextFontSize;
LensUnit.Editable = 'off'; LensUnit.Enable = 'off';


HeightStart = HeightStart-TextHeight-SpaceSize;
WidthStart = SpaceSize;

% Sinusoidal Mode
% Text "Frequency"
SinusFrequencyLabel = uilabel(LensPanel);
SinusFrequencyLabel.Position=[WidthStart HeightStart 7.5*TextFontSize TextHeight];
SinusFrequencyLabel.Text = 'Frequency (Hz)'; SinusFrequencyLabel.FontWeight = 'bold'; SinusFrequencyLabel.FontSize = TextFontSize;
WidthStart = WidthStart+7.5*TextFontSize;
% Value
SinusFrequencyValue = uieditfield(LensPanel,'numeric');
SinusFrequencyValue.Position = [WidthStart HeightStart 3*TextFontSize TextHeight];
SinusFrequencyValue.ValueDisplayFormat = '%1.1f';
SinusFrequencyValue.Value = 1; SinusFrequencyValue.FontWeight = 'bold'; SinusFrequencyValue.FontSize = TextFontSize;
SinusFrequencyValue.Limits = [0 10]; SinusFrequencyValue.LowerLimitInclusive = 'on'; SinusFrequencyValue.UpperLimitInclusive = 'on';

WidthStart = WidthStart+3*TextFontSize+SpaceSize;
% Text "Min"
SinusMinLabel = uilabel(LensPanel);
SinusMinLabel.Position=[WidthStart HeightStart 2.1*TextFontSize TextHeight];
SinusMinLabel.Text = 'Min'; SinusMinLabel.FontWeight = 'bold'; SinusMinLabel.FontSize = TextFontSize;
WidthStart = WidthStart+2.1*TextFontSize;
% Value
SinusMinValue = uieditfield(LensPanel,'numeric');
SinusMinValue.Position = [WidthStart HeightStart 2.5*TextFontSize TextHeight];
SinusMinValue.ValueDisplayFormat = '%1.1f';
SinusMinValue.Value = 0; SinusMinValue.FontWeight = 'bold'; SinusMinValue.FontSize = TextFontSize;
SinusMinValue.Limits = [0 5]; SinusMinValue.LowerLimitInclusive = 'on'; SinusMinValue.UpperLimitInclusive = 'on';

WidthStart = WidthStart+2.5*TextFontSize+SpaceSize;
% Text "Max"
SinusMaxLabel = uilabel(LensPanel);
SinusMaxLabel.Position=[WidthStart HeightStart 2.1*TextFontSize TextHeight];
SinusMaxLabel.Text = 'Max'; SinusMaxLabel.FontWeight = 'bold'; SinusMaxLabel.FontSize = TextFontSize;
WidthStart = WidthStart+2.1*TextFontSize;
% Value
SinusMaxValue = uieditfield(LensPanel,'numeric');
SinusMaxValue.Position = [WidthStart HeightStart 2.5*TextFontSize TextHeight];
SinusMaxValue.ValueDisplayFormat = '%1.1f';
SinusMaxValue.Value = 3; SinusMaxValue.FontWeight = 'bold'; SinusMaxValue.FontSize = TextFontSize;
SinusMaxValue.Limits = [0 5]; SinusMaxValue.LowerLimitInclusive = 'on'; SinusMaxValue.UpperLimitInclusive = 'on';

WidthStart = WidthStart+2.5*TextFontSize;
% Unit
SinUnit = uieditfield(LensPanel);
SinUnit.Position = [WidthStart HeightStart 2*TextFontSize TextHeight];
SinUnit.Value = 'V'; SinUnit.FontWeight = 'bold'; SinUnit.FontSize = TextFontSize;
SinUnit.Editable = 'off'; SinUnit.Enable = 'off';
% By default, grey all thing related to sinusoïdal mode
EnableLensPeriodic('off',LensPanel);
% Intialise as a 0-3 V peak to peak signal, frequency 1Hz
SetLensPeriodic(Lens,1,0,3);


%% Camera control panel
CameraPanel = uipanel(Main); 
CameraPanel.Units='pixels';
CameraPanelHeight = 4.8*TextHeight;
PanelHeightStart = PanelHeightStart-SpaceSize-CameraPanelHeight;
CameraPanel.Position=[SpaceSize PanelHeightStart CommandWidth-2*SpaceSize CameraPanelHeight];
CameraPanel.BorderType = 'line';
CameraPanel.BackgroundColor = DarkGray;
% Title
CameraPanel.FontSize = TitleFontSize;
CameraPanel.Title = 'CAMERA'; CameraPanel.TitlePosition = 'centertop';

HeightStart = CameraPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = SpaceSize;

% Exposure Time
% Text "Exposure Time"
ExposureLabel = uilabel(CameraPanel);
ExposureLabel.Position=[WidthStart HeightStart 7*TextFontSize TextHeight];
ExposureLabel.Text = 'Exposure (ms)'; ExposureLabel.FontWeight = 'bold'; ExposureLabel.FontSize = TextFontSize;
WidthStart3 = WidthStart+7*TextFontSize;
% Exposure Time
ExposureValue = uieditfield(CameraPanel,'numeric');
ExposureValue.Position = [WidthStart3 HeightStart 5*TextFontSize TextHeight];
ExposureValue.ValueDisplayFormat = '%d';
ExposureValue.Value = 100; ExposureValue.FontWeight = 'bold'; ExposureValue.FontSize = TextFontSize;
ExposureValue.Limits = [0 100000]; ExposureValue.LowerLimitInclusive = 'on'; ExposureValue.UpperLimitInclusive = 'on';
% Initialise with a 100 ms exposure time
SetCameraExposure(Camera,100);
WidthStart4 = WidthStart3+5*TextFontSize+2*SpaceSize;

% Check Box "ROI Centered"
ROICentered = uicheckbox(CameraPanel);
ROICentered.Position=[WidthStart4+0.5*TextFontSize HeightStart 8.5*TextFontSize TextHeight];
ROICentered.Text = 'ROI Centered'; ROICentered.FontWeight = 'bold'; ROICentered.FontSize = TextFontSize;
ROICentered.Value = 1;

% ROI
HeightStart = HeightStart-TextHeight-SpaceSize;
% Text "ROI"
ROILabel = uilabel(CameraPanel);
ROILabel.Position=[WidthStart HeightStart 3*TextFontSize TextHeight];
ROILabel.Text = 'ROI'; ROILabel.FontWeight = 'bold'; ROILabel.FontSize = TextFontSize;
WidthStart2 = WidthStart+3*TextFontSize;
% Text "Width"
ROIWidthLabel = uilabel(CameraPanel);
ROIWidthLabel.Position=[WidthStart2 HeightStart 4*TextFontSize TextHeight];
ROIWidthLabel.Text = 'Width'; ROIWidthLabel.FontWeight = 'bold'; ROIWidthLabel.FontSize = TextFontSize;
% Width
ROIWidthValue = uieditfield(CameraPanel,'numeric');
ROIWidthValue.Position = [WidthStart3 HeightStart 5*TextFontSize TextHeight];
ROIWidthValue.ValueDisplayFormat = '%d';
ROIWidthValue.Value = SensorSize; ROIWidthValue.FontWeight = 'bold'; ROIWidthValue.FontSize = TextFontSize;
ROIWidthValue.Limits = [0 SensorSize]; ROIWidthValue.LowerLimitInclusive = 'on'; ROIWidthValue.UpperLimitInclusive = 'on';
WidthStart4 = WidthStart3+5*TextFontSize+3*SpaceSize;

% Text "Left"
ROILeftLabel = uilabel(CameraPanel);
ROILeftLabel.Position=[WidthStart4 HeightStart 4*TextFontSize TextHeight];
ROILeftLabel.Text = 'Left'; ROILeftLabel.FontWeight = 'bold'; ROILeftLabel.FontSize = TextFontSize;
WidthStart5 = WidthStart4+3*TextFontSize;
% Width
ROILeftValue = uieditfield(CameraPanel,'numeric');
ROILeftValue.Position = [WidthStart5 HeightStart 5*TextFontSize TextHeight];
ROILeftValue.ValueDisplayFormat = '%d';
ROILeftValue.Value = 0; ROILeftValue.FontWeight = 'bold'; ROILeftValue.FontSize = TextFontSize;
ROILeftValue.Limits = [0 SensorSize]; ROILeftValue.LowerLimitInclusive = 'on'; ROILeftValue.UpperLimitInclusive = 'on';
%ROILeftValue.Enable = 'off';

HeightStart2 = HeightStart-TextHeight;
% Text "Height"
ROIHeightLabel = uilabel(CameraPanel);
ROIHeightLabel.Position=[WidthStart2 HeightStart2 4*TextFontSize TextHeight];
ROIHeightLabel.Text = 'Height'; ROIHeightLabel.FontWeight = 'bold'; ROIHeightLabel.FontSize = TextFontSize;
% Width
ROIHeightValue = uieditfield(CameraPanel,'numeric');
ROIHeightValue.Position = [WidthStart3 HeightStart2 5*TextFontSize TextHeight];
ROIHeightValue.ValueDisplayFormat = '%d';
ROIHeightValue.Value = SensorSize; ROIHeightValue.FontWeight = 'bold'; ROIHeightValue.FontSize = TextFontSize;
ROIHeightValue.Limits = [0 SensorSize]; ROIHeightValue.LowerLimitInclusive = 'on'; ROIHeightValue.UpperLimitInclusive = 'on';

% Text "Top"
ROITopLabel = uilabel(CameraPanel);
ROITopLabel.Position=[WidthStart4 HeightStart2 4*TextFontSize TextHeight];
ROITopLabel.Text = 'Top'; ROITopLabel.FontWeight = 'bold'; ROITopLabel.FontSize = TextFontSize;
% Width
ROITopValue = uieditfield(CameraPanel,'numeric');
ROITopValue.Position = [WidthStart5 HeightStart2 5*TextFontSize TextHeight];
ROITopValue.ValueDisplayFormat = '%d';
ROITopValue.Value = 0; ROITopValue.FontWeight = 'bold'; ROITopValue.FontSize = TextFontSize;
ROITopValue.Limits = [0 SensorSize]; ROITopValue.LowerLimitInclusive = 'on'; ROITopValue.UpperLimitInclusive = 'on';
%ROITopValue.Enable = 'off';
WidthStart6 = WidthStart5+5*TextFontSize+7*SpaceSize;
% Initialise with full sensor
SetCameraROI(Camera,0,0,0,SensorSize,SensorSize);

%DropDown panel
CameraDDPanel = uipanel(CameraPanel); 
CameraDDPanel.Units='pixels';
CameraDDPanelHeight = 3.5*TextHeight;
PanelHeightStartDD = CameraPanelHeight-TextHeight-2*SpaceSize-CameraDDPanelHeight;
CameraDDPanel.Position=[WidthStart6 PanelHeightStartDD CommandWidth-WidthStart6-2*SpaceSize CameraDDPanelHeight];
CameraDDPanel.BorderType = 'line';
CameraDDPanel.BackgroundColor = DarkGray;

HeightStart = CameraDDPanelHeight-TextHeight-SpaceSize;
WidthStart = 2*SpaceSize;

% Readout
% Text "Readout"
ReadoutModeLabel = uilabel(CameraDDPanel);
ReadoutModeLabel.Position=[WidthStart HeightStart 5*TextFontSize TextHeight];
ReadoutModeLabel.Text = 'Readout'; ReadoutModeLabel.FontWeight = 'bold'; ReadoutModeLabel.FontSize = TextFontSize;
WidthStart2 = WidthStart+5*TextFontSize;
% Readout Mode Drop Down
ReadoutMode = uidropdown(CameraDDPanel);
ReadoutMode.Position = [WidthStart2 HeightStart 10*TextFontSize TextHeight];
ReadoutMode.Items = {'11bit Full Well', '11bit Balanced', '11bit Sensitivity', '12bit CMS', '16bit HDR'};
ReadoutMode.FontWeight = 'bold'; ReadoutMode.FontSize = TextFontSize;
% Initialise as 16bit HDR
ReadoutMode.Value = '16bit HDR'; SetReadoutCamera(Camera, '16bit HDR')

HeightStart = HeightStart-TextHeight;
% Trigger
% Text "Trigger"
TriggerModeLabel = uilabel(CameraDDPanel);
TriggerModeLabel.Position=[WidthStart HeightStart 5*TextFontSize TextHeight];
TriggerModeLabel.Text = 'Trigger'; TriggerModeLabel.FontWeight = 'bold'; TriggerModeLabel.FontSize = TextFontSize;
% Readout Mode Drop Down
TriggerMode = uidropdown(CameraDDPanel);
TriggerMode.Position = [WidthStart2 HeightStart 10*TextFontSize TextHeight];
TriggerMode.Items = {'internal', 'external'};
TriggerMode.FontWeight = 'bold'; TriggerMode.FontSize = TextFontSize;
% Initialise as 'internal'
TriggerMode.Value = 'internal'; SetTriggerCamera(Camera,'internal');

HeightStart = HeightStart-TextHeight-SpaceSize;
% Live
CameraLiveButton = uibutton(CameraDDPanel,'state');
CameraLiveButton.Text = 'LIVE'; CameraLiveButton.FontWeight = 'bold'; CameraLiveButton.FontSize = TextFontSize;
CameraLiveButton.Position=[WidthStart HeightStart 4.5*TextFontSize TextHeight]; 
% Save 1 image
CameraSave1Button = uibutton(CameraDDPanel);
CameraSave1Button.Text = 'SAVE LAST IMAGE'; CameraSave1Button.FontWeight = 'bold'; CameraSave1Button.FontSize = TextFontSize;
CameraSave1Button.Position=[WidthStart+5*TextFontSize HeightStart 10*TextFontSize TextHeight]; 


%% Acquisition control panel
AcquisitionPanel = uipanel(Main);
AcquisitionPanel.Units='pixels';
AcquisitionPanelHeight = 9*TextHeight;
AcquisitionPanelWidth = CommandWidth-2*SpaceSize;
PanelHeightStart = PanelHeightStart-SpaceSize-AcquisitionPanelHeight;
AcquisitionPanel.Position=[SpaceSize PanelHeightStart AcquisitionPanelWidth AcquisitionPanelHeight];
AcquisitionPanel.BorderType = 'line';
AcquisitionPanel.BackgroundColor = DarkGray;
% Title
AcquisitionPanel.FontSize = TitleFontSize;
AcquisitionPanel.Title = 'ACQUISITION'; AcquisitionPanel.TitlePosition = 'centertop';

HeightStart = AcquisitionPanelHeight-2*TextHeight-3*SpaceSize;
WidthStart = SpaceSize;


% Choose folder
% Create default date folder
Camera.SetDatePath();
% Display "Current path"
SaveFolderDisplay = uieditfield(AcquisitionPanel);
SaveFolderLength = AcquisitionPanelWidth-2*SpaceSize-2*TextFontSize;
SaveFolderDisplay.Position = [WidthStart HeightStart SaveFolderLength TextHeight];
SaveFolderDisplay.Value = Camera.SavePath; SaveFolderDisplay.FontSize = TextFontSize;
SaveFolderDisplay.Editable = 'off'; 
WidthStart = WidthStart+SaveFolderLength;
% Button "Choose folder"
SaveFolderButton = uibutton(AcquisitionPanel);
[folderjpg,map]=imread('Folder.jpg');
SaveFolderButton.Text = ''; SaveFolderButton.Icon = folderjpg;
SaveFolderButton.Position=[WidthStart HeightStart AcquisitionPanelWidth-SaveFolderLength-2*SpaceSize TextHeight]; 


HeightStart = HeightStart-TextHeight-SpaceSize;
WidthStart = SpaceSize;
% Lens parameters
% Text "Lens Range"
LensRangeLabel = uilabel(AcquisitionPanel);
LensRangeLabel.Position=[WidthStart HeightStart 11*TextFontSize TextHeight];
LensRangeLabel.Text = 'Lens Range (Dioptries)'; LensRangeLabel.FontWeight = 'bold'; LensRangeLabel.FontSize = TextFontSize;
WidthStart = WidthStart+11*TextFontSize;
% Lens Min
LensMinValue = uieditfield(AcquisitionPanel,'numeric');
LensMinValue.Position = [WidthStart HeightStart 4*TextFontSize TextHeight];
LensMinValue.ValueDisplayFormat = '%1.2f';
LensMinValue.Value = -1.5; LensMinValue.FontWeight = 'bold'; LensMinValue.FontSize = TextFontSize;
LensMinValue.Limits = [-1.5 5.5]; LensMinValue.LowerLimitInclusive = 'on'; LensMinValue.UpperLimitInclusive = 'on';
WidthStart = WidthStart+4*TextFontSize+SpaceSize;
% Text "TO"
LensTOLabel = uilabel(AcquisitionPanel);
LensTOLabel.Position=[WidthStart HeightStart 2*TextFontSize TextHeight];
LensTOLabel.Text = 'to'; LensTOLabel.FontWeight = 'bold'; LensTOLabel.FontSize = TextFontSize;
WidthStart = WidthStart+TextFontSize+SpaceSize;
% Lens Max
LensMaxValue = uieditfield(AcquisitionPanel,'numeric');
LensMaxValue.Position = [WidthStart HeightStart 4*TextFontSize TextHeight];
LensMaxValue.ValueDisplayFormat = '%1.2f';
LensMaxValue.Value = 1.5; LensMaxValue.FontWeight = 'bold'; LensMaxValue.FontSize = TextFontSize;
LensMaxValue.Limits = [-1.5 5.5]; LensMaxValue.LowerLimitInclusive = 'on'; LensMaxValue.UpperLimitInclusive = 'on';
WidthStart = WidthStart+4*TextFontSize+SpaceSize;
% Text "BY"
LensBYLabel = uilabel(AcquisitionPanel);
LensBYLabel.Position=[WidthStart HeightStart 2*TextFontSize TextHeight];
LensBYLabel.Text = 'by'; LensBYLabel.FontWeight = 'bold'; LensBYLabel.FontSize = TextFontSize;
WidthStart = WidthStart+TextFontSize+SpaceSize;
% Lens Step
LensStepValue = uieditfield(AcquisitionPanel,'numeric');
LensStepValue.Position = [WidthStart HeightStart 4*TextFontSize TextHeight];
LensStepValue.ValueDisplayFormat = '%1.2f';
LensStepValue.Value = 0.05; LensStepValue.FontWeight = 'bold'; LensStepValue.FontSize = TextFontSize;
LensStepValue.Limits = [0 7]; LensStepValue.LowerLimitInclusive = 'on'; LensStepValue.UpperLimitInclusive = 'on';
WidthStart = WidthStart+4*TextFontSize+2*SpaceSize;
% Text "0.05 Dioptrie ~ 150 nm"
LensScaleLabel = uilabel(AcquisitionPanel);
LensScaleLabel.Position=[WidthStart HeightStart 13*TextFontSize TextHeight];
LensScaleLabel.Text = 'with 0.05 Dioptries ~ 150 nm'; LensScaleLabel.FontSize = TextFontSize;
WidthStart2 = WidthStart;

HeightStart = HeightStart-TextHeight-SpaceSize;
WidthStart = SpaceSize;
% Speckle parameters
% Text "Number of speckles"
NumberSpeckleLabel = uilabel(AcquisitionPanel);
NumberSpeckleLabel.Position=[WidthStart HeightStart 11*TextFontSize TextHeight];
NumberSpeckleLabel.Text = 'Number of Speckles'; NumberSpeckleLabel.FontWeight = 'bold'; NumberSpeckleLabel.FontSize = TextFontSize;
WidthStart = WidthStart+11*TextFontSize;
% Number of speckles
NumberSpeckleValue = uieditfield(AcquisitionPanel,'numeric');
NumberSpeckleValue.Position = [WidthStart HeightStart 4*TextFontSize TextHeight];
NumberSpeckleValue.ValueDisplayFormat = '%d';
NumberSpeckleValue.Value = -1.5; NumberSpeckleValue.FontWeight = 'bold'; NumberSpeckleValue.FontSize = TextFontSize;
NumberSpeckleValue.Limits = [1 inf]; NumberSpeckleValue.LowerLimitInclusive = 'on';


% Start Acquisition
StartAcquisitionButton = uibutton(AcquisitionPanel);
StartAcquisitionButton.Text = 'START ACQUISITION'; StartAcquisitionButton.FontWeight = 'bold'; StartAcquisitionButton.FontSize = TextFontSize;
StartAcquisitionButton.Position=[WidthStart2 HeightStart 13*TextFontSize TextHeight];


HeightStart = HeightStart-2*TextHeight-SpaceSize;
WidthStart = SpaceSize;
% Text "Info for txt file"
InfoTXTLabel = uilabel(AcquisitionPanel);
InfoTXTLabel.Position=[WidthStart HeightStart 18*TextFontSize TextHeight];
InfoTXTLabel.Text = 'Infos for the ExperimentData.txt file'; InfoTXTLabel.FontSize = TextFontSize;
WidthStart = WidthStart+18*TextFontSize;

% Text "Sample"
SampleLabel = uilabel(AcquisitionPanel);
SampleLabel.Position=[WidthStart HeightStart 4*TextFontSize TextHeight];
SampleLabel.Text = 'Sample:'; SampleLabel.FontSize = TextFontSize;
WidthStart = WidthStart+4*TextFontSize;
% Sample Name
SampleName = uieditfield(AcquisitionPanel);
SampleName.Position = [WidthStart HeightStart 17*TextFontSize TextHeight];
SampleName.Value = 'Experiment of the year'; SampleName.FontSize = TextFontSize;


HeightStart = HeightStart-TextHeight-SpaceSize;
WidthStart = SpaceSize;
% Text "Objective"
ObjectiveLabel = uilabel(AcquisitionPanel);
ObjectiveLabel.Position=[WidthStart HeightStart 5*TextFontSize TextHeight];
ObjectiveLabel.Text = 'Objective:'; ObjectiveLabel.FontSize = TextFontSize;
WidthStart = WidthStart+5*TextFontSize;
% User Name
ObjectiveName = uieditfield(AcquisitionPanel);
ObjectiveName.Position = [WidthStart HeightStart 11*TextFontSize TextHeight];
ObjectiveName.Value = '100x / Oil / NA 1.3'; ObjectiveName.FontSize = TextFontSize;
WidthStart = WidthStart+13*TextFontSize;

% Text "User"
UserLabel = uilabel(AcquisitionPanel);
UserLabel.Position=[WidthStart HeightStart 4*TextFontSize TextHeight];
UserLabel.Text = 'User:'; UserLabel.FontSize = TextFontSize;
WidthStart = WidthStart+4*TextFontSize;
% User Name
UserName = uieditfield(AcquisitionPanel);
UserName.Position = [WidthStart HeightStart 11*TextFontSize TextHeight];
UserName.Value = 'Captain Nemo'; UserName.FontSize = TextFontSize;


HeightStart = HeightStart-TextHeight;
WidthStart = SpaceSize;
% Text Naming convention
NamingLabel = uilabel(AcquisitionPanel);
NamingLabel.Position=[WidthStart HeightStart AcquisitionPanelWidth-2*SpaceSize TextHeight];
NamingLabel.Text = 'Naming convention: SpeckleXXXLensYYY with XXX = Speckle Number and YYY = 100*(Lens Focal Power+1.5)'; NamingLabel.FontSize = TextFontSize*0.8;

Main.UserData{1} = SampleName.Value;
Main.UserData{2} = UserName.Value;
Main.UserData{3} = ObjectiveName.Value;

HeightStart = HeightStart-TextHeight-SpaceSize;
WidthStart = SpaceSize;
% Text Naming convention
NamingLabel = uilabel(AcquisitionPanel);
NamingLabel.Position=[WidthStart HeightStart AcquisitionPanelWidth-2*SpaceSize TextHeight];
NamingLabel.Text = 'Naming convention: SpeckleXXXLensYYY with XXX = Speckle Number and YYY = 100*(Lens Focal Power+1.5)'; NamingLabel.FontSize = TextFontSize*0.8;




%% All button actions here as matlab cannot find a variable if it is after the call of the function
% Piezo XY
set(VelocityXYValue,'ValueChangedFcn',@(src,event) PiezoSetXYVelocity(Piezo,VelocityXYValue.Value));
% Set the velocity once ass this is a value "stored" on piezo controler
set(BouttonXY_Up,'ButtonPushedFcn',@(src,event) PiezoMove(Piezo,'X',StepXYValue.Value,1,XPosition,YPosition,ZPosition));
set(BouttonXY_Left,'ButtonPushedFcn',@(src,event) PiezoMove(Piezo,'Y',StepXYValue.Value,-1,XPosition,YPosition,ZPosition));
set(BouttonXY_Right,'ButtonPushedFcn',@(src,event) PiezoMove(Piezo,'Y',StepXYValue.Value,1,XPosition,YPosition,ZPosition));
set(BouttonXY_Down,'ButtonPushedFcn',@(src,event) PiezoMove(Piezo,'X',StepXYValue.Value,-1,XPosition,YPosition,ZPosition));
% PiezoMove input: Piezo (class), Axes (string), StepSize (number), Direction (1 or -1), Dispaly for current positions.
set(HomeXYButton,'ButtonPushedFcn',@(src,event) PiezoHome(Piezo,'XY'));
set(GoToXYButton,'ButtonPushedFcn',@(src,event) PiezoGoTo(Piezo,'XY',GoToXPosition.Value,GoToYPosition.Value));

% Piezo Z
set(VelocityZValue,'ValueChangedFcn',@(src,event) PiezoSetZVelocity(Piezo,VelocityZValue.Value));
set(BouttonZ_Up,'ButtonPushedFcn',@(src,event) PiezoMove(Piezo,'Z',StepZValue.Value,1,XPosition,YPosition,ZPosition));
set(BouttonZ_Down,'ButtonPushedFcn',@(src,event) PiezoMove(Piezo,'Z',StepZValue.Value,-1,XPosition,YPosition,ZPosition));
set(HomeZButton,'ButtonPushedFcn',@(src,event) PiezoHome(Piezo,'Z'));
set(GoToZButton,'ButtonPushedFcn',@(src,event) PiezoGoTo(Piezo,'Z',GoToZPosition.Value));

% Diffuser
set(DiffuserStepButton,'ButtonPushedFcn',@(src,event) DiffuserStep(Diffuser,DiffuserStepValue.Value));
set(DiffuserVelocityValue,'ValueChangedFcn',@(src,event) DiffuserSetVelocity(Diffuser,DiffuserVelocityValue.Value));
set(DiffuserRotateButton,'ValueChangedFcn',@(src,event) DiffuserRotate(Diffuser,DiffuserRotateButton.Value));

% Lens
set(LensMode,'ValueChangedFcn',@(src,event) SetLensMode(Lens,LensMode.Value,LensPanel));
set(LensValue,'ValueChangedFcn',@(src,event) SetLensValue(Lens,LensMode.Value,LensValue.Value));
set(SinusFrequencyValue,'ValueChangedFcn',@(src,event) SetLensPeriodic(Lens,SinusFrequencyValue.Value,SinusMinValue.Value,SinusMaxValue.Value));
set(SinusMinValue,'ValueChangedFcn',@(src,event) SetLensPeriodic(Lens,SinusFrequencyValue.Value,SinusMinValue.Value,SinusMaxValue.Value));
set(SinusMaxValue,'ValueChangedFcn',@(src,event) SetLensPeriodic(Lens,SinusFrequencyValue.Value,SinusMinValue.Value,SinusMaxValue.Value));

% Camera
set(ExposureValue,'ValueChangedFcn',@(src,event) SetCameraExposure(Camera,ExposureValue.Value));
set(ROICentered,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROICentered.Value,ROILeftValue.Value,ROITopValue.Value,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage));
set(ROIWidthValue,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROICentered.Value,ROILeftValue.Value,ROITopValue.Value,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage));
set(ROILeftValue,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROICentered.Value,ROILeftValue.Value,ROITopValue.Value,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage));
set(ROIHeightValue,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROICentered.Value,ROILeftValue.Value,ROITopValue.Value,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage));
set(ROITopValue,'ValueChangedFcn',@(src,event) SetCameraROI(Camera,ROICentered.Value,ROILeftValue.Value,ROITopValue.Value,ROIWidthValue.Value,ROIHeightValue.Value,CameraImage));
set(ReadoutMode,'ValueChangedFcn',@(src,event) SetReadoutCamera(Camera,ReadoutMode.Value));
set(TriggerMode,'ValueChangedFcn',@(src,event) SetTriggerCamera(Camera,TriggerMode.Value));
set(CameraLiveButton,'ValueChangedFcn',@(src,event) CameraLive(Camera,CameraImage,CameraLiveButton.Value));
set(CameraSave1Button,'ButtonPushedFcn',@(src,event) CameraSaveLast(Camera));

% Acquisition
set(SaveFolderButton,'ButtonPushedFcn',@(src,event) ChooseSaveFolder(SaveFolderDisplay));
set(StartAcquisitionButton,'ButtonPushedFcn',@(src,event) StartAcquisition(Camera, Lens, LensMinValue.Value, LensMaxValue.Value, LensStepValue.Value, Diffuser, NumberSpeckleValue.Value, SaveFolderDisplay.Value, Main.UserData));


%% Functions

% Piezo
function PiezoSetXYVelocity(Piezo,Velocity)
    Piezo.SetVelocity('X',Velocity);
    Piezo.SetVelocity('Y',Velocity);
end

function PiezoSetZVelocity(Piezo,Velocity)
    Piezo.SetVelocity('Z',Velocity);
end

function PiezoMove(Piezo,Axe,StepValue,Direction,DisplayX,DisplayY,DisplayZ)
    % input: Piezo (class), Axes (string), StepSize (number), Direction (1 or -1), Displays for current position.
    Piezo.Move(Axe,'Relative',StepValue*Direction);
    % Nouvelle fonction Move doit contenir l'axe
    % 
    DisplayX.Value = Piezo.GetPosition('X');
    DisplayY.Value = Piezo.GetPosition('Y');
    DisplayZ.Value = Piezo.GetPosition('Z');
    % Nouvelle fonction GetPosition doit contenir l'axe
end


function PiezoHome(Piezo,Axe)
    if strcmp(Axe,'XY')
        Piezo.Move('X','Home')
        Piezo.Move('Y','Home')
    elseif strcmp(Axe,'Z')
        Piezo.Move('Z','Home')
    end
end

function PiezoGoTo(Piezo,Axe,varargin)
    if strcmp(Axe,'XY')
        Piezo.Move('X','Absolute',varargin{1})
        Piezo.Move('Y','Absolute',varargin{2})
    elseif strcmp(Axe,'Z')
        Piezo.Move('Z','Absolute',varargin{1})
    end
end


% Diffuser
function DiffuserSetVelocity(Diffuser,Velocity)
    Diffuser.SetVelocity(Velocity);
end

function DiffuserStep(Diffuser,Angle)
    Diffuser.Rotate(Angle,'Clockwise');
end

function DiffuserRotate(Diffuser,DiffuserRotateValue)
    if DiffuserRotateValue == 1
        Diffuser.RotateContinuous('Clockwise');
    else
        Diffuser.StopRotation();
    end
end

% Lens
function SetLensMode(Lens,Mode,LensPanel)
    if strcmp (Mode,'Analog')
        % Set Mode Analog
        Lens.SetModeAnalog();
        % Disable and grey out all controls
        EnableLensConstant('off',LensPanel);
        EnableLensPeriodic('off',LensPanel);
    elseif strcmp (Mode,'Current')
        Lens.SetModeCurrent();
        % Disable and grey out periodic controls. Enable Constant controls.
        EnableLensConstant('on',LensPanel);
        EnableLensPeriodic('off',LensPanel);
        % Set unit to V
        % LensUnit.Value = 'V';
        LensPanel.Children(8).Value = 'V';
    elseif strcmp (Mode,'Focal Power')
        Lens.SetModeFocalPower();
        % Disable and grey out periodic controls. Enable Constant controls.
        EnableLensConstant('on',LensPanel);
        EnableLensPeriodic('off',LensPanel);
        % Set unit to Dioptries
        % LensUnit.Value = 'Dioptries';
        LensPanel.Children(8).Value = 'Dioptries';
    elseif strcmp (Mode,'Sinusoidal')
        Lens.SetModeSinusoidal();
        % Disable and grey out Constant controls. Enable Periodic controls.
        EnableLensConstant('off',LensPanel);
        EnableLensPeriodic('on',LensPanel);   
    elseif strcmp (Mode,'Triangular')
        Lens.SetModeTriangular();
        % Disable and grey out Constant controls. Enable Periodic controls.
        EnableLensConstant('off',LensPanel);
        EnableLensPeriodic('on',LensPanel);
    elseif strcmp (Mode,'Rectangular')
        Lens.SetModeRectangular();
        % Disable and grey out Constant controls. Enable Periodic controls.
        EnableLensConstant('off',LensPanel);
        EnableLensPeriodic('on',LensPanel);
    end
end

function EnableLensConstant(boolean,LensPanel)
    %LensValueLabel.Enable = boolean;
    LensPanel.Children(10).Enable = boolean;
    %LensValue.Enable = boolean;
    LensPanel.Children(9).Enable = boolean;
end

function EnableLensPeriodic(boolean,LensPanel)
    %SinusFrequencyLabel.Enable = boolean;
    LensPanel.Children(7).Enable = boolean;
    %SinusFrequencyValue.Enable = boolean;
    LensPanel.Children(6).Enable = boolean;
    %SinusMinLabel.Enable = boolean;
    LensPanel.Children(5).Enable = boolean;
    %SinusMinValue.Enable = boolean;
    LensPanel.Children(4).Enable = boolean;
    %SinusMaxLabel.Enable = boolean;
    LensPanel.Children(3).Enable = boolean;
    %SinusMaxValue.Enable = boolean;
    LensPanel.Children(2).Enable = boolean;   
end

function SetLensValue(Lens,Mode,Value)
    % check if we are in Current or Focal Power mode
    if strcmp (Mode, 'Current')
        Lens.SetCurrent(Value);
    elseif strcmp (Mode, 'Focal Power')
        Lens.SetFocalPower(Value);
    end
end

function SetLensPeriodic(Lens,Frequency,Min,Max)
    Lens.SetFrequency(Frequency);
    Lens.SetPeakToPeak(Min, Max);
end


% Camera
function SetCameraExposure(Camera,ExposureTime)
    Camera.SetExposure(ExposureTime);
end

function SetCameraROI(Camera,Centered,deltaX,deltaY,Width,Height,CameraImage)
    if Centered == 1
        Camera.SetROICentered(Width,Height);
    else
        Camera.SetROICustom(deltaX,deltaY,Width,Height);
    end
    % Update size of the display
    SquareSize = max(Width,Height);
    CameraImage.XLim = [0,SquareSize]; CameraImage.YLim = [0,SquareSize];
end

function SetReadoutCamera(Camera,ReadoutMode)
    if strcmp (ReadoutMode, '11bit Full Well')
        Camera.SetReadoutMode('Port0-Speed0-200MHz-11bit-Gain1-Full well');
    elseif strcmp (ReadoutMode, '11bit Balanced')
        Camera.SetReadoutMode('Port0-Speed0-200MHz-11bit-Gain2-Balanced');
    elseif strcmp (ReadoutMode, '11bit Sensitivity')
        Camera.SetReadoutMode('Port0-Speed0-200MHz-11bit-Gain3-Sensitivity');
    elseif strcmp (ReadoutMode, '12bit CMS')
        Camera.SetReadoutMode('Port0-Speed1-100MHz-12bit-Gain2-CMS');
    elseif strcmp (ReadoutMode, '16bit HDR')
        Camera.SetReadoutMode('Port0-Speed1-100MHz-16bit-Gain1-HDR');
    end
end

function SetTriggerCamera(Camera,TriggerMode)
    Camera.SetTriggerMode(TriggerMode)
end

function CameraLive(Camera,CameraImage,CameraLiveValue)
    if CameraLiveValue == 1
        Camera.IsLiveON = true;
        Camera.StartCapture();
        while Camera.IsLiveON == true
            Camera.Capture1more();  %Capture the image
            Camera.Get1more();      %Read the image
            imagesc(CameraImage,Camera.Image);
        end
        Camera.StopCapture();
    else
        Camera.IsLiveON = false;
    end
end

function CameraSaveLast(Camera)
    SaveName = uigetfile(Camera.SavePath);
    imwrite(Camera.Image, SaveName);
end

% Acquisition
function ChooseSaveFolder(SaveFolder)
    SaveFolder.Value = uigetdir(SaveFolder.Value);
end

function StartAcquisition(Camera, Lens, LensMin, LensMax, LensStep, Diffuser, NumberSpeckles, SaveFolder, UserData)
    % Piezo is not moving during the acquisition, so not as input
    % All camera parameters are normally set either at startup, or when modifying one. So no need to have them as inputs.
    % Only recording folder need to be set
    Camera.SaveFolder = SaveFolder;
    % Check if Folder is empty, else open a user interface to ask for another folder
    if ~isempty(Camera.SaveFolder)
        Camera.SaveFolder = uigetdir(Camera.SaveFolder);
    end
    % Lens has to be set back in Focal Power Mode to benefit from temperature feedback
    Lens.SetModeFocalPower();
    Lens.SetFocalPower(LensMin);
    % Number of Lens steps
    NStepsLens = 1 + floor((LensMax-LensMin)/LensStep);
    % Rotation of the diffuser between each speckle.
    DiffuserAngle = max(360/NumberSpeckles,1);
   
    % Save a txt file with experimental parameters
    fileID = fopen(fullfile(Camera.SaveFolder,'ExperimentData.txt'),'w');
    fprintf(fileID,'Date of Experiment: %s \n', datetime('now','Format','yyyy-MM-dd'));
    fprintf(fileID,'Sample: %s \n', UserData{1});
    fprintf(fileID,'Experimentalist: %s \n', UserData{2});
    fprintf(fileID,'Objective: %s \n', UserData{3});
    fprintf(fileID,'CAMERA_PARAMETERS \n');
    fprintf(fileID,'Exposure_Time(ms): %.0f \n', Camera.ExposureTime);
    fprintf(fileID,'Image_Size_(pixels): %.0f, %.0f \n', Camera.ROIWidth, Camera.ROIHeight); 
    fprintf(fileID,'Readout_Mode: %s \n', Camera.ReadoutMode);
    fprintf(fileID,'LENS_PARAMETERS \n');
    fprintf(fileID,'Focal Power Range (Dioptries): %.3f to %.3f \n', LensMin, LensMax);
    fprintf(fileID,'Focal Power Step (Dioptries): %.3f \n', LensStep);
    fprintf(fileID,'SPECKLE_PARAMETERS \n');
    fprintf(fileID,'Number of Speckles: %.0f \n', NumberSpeckles);
    fclose(fileID);
    
    % Get camera ready
    Camera.StartCapture();

    for i = 1:NumberSpeckles
        % Display current speckle
        disp(i);
        % Restart the Lens sweep
        LensPower = LensMin;
        Lens.SetFocalPower(LensPower);
        
        for j = 1:NStepsLens
            % Capture image
            Camera.Capture1more();
            % Set savename
            SaveName = strcat('Speckle',num2str(i,'%03d'),'Lens',num2str(100*(LensPower+1.5),'%03.0f'));
            Camera.SetSaveName('Manual',SaveName);
            % Set the Focal Power of the lens
            LensPower = LensMin + j*LensStep;
            Lens.SetFocalPower(LensPower);
            % While lens is stabilizing, read and save the image
            Camera.Save1more();
        end
    % Go to next speckle
    Diffuser.Rotate(DiffuserAngle,'Clockwise');
    % Make sure speckle has been changed
    pause(1);
    end
    
% Stop acquisition
Camera.StopCapture();
end

