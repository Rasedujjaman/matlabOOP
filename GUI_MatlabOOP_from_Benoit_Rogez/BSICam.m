classdef BSICam < handle
    %BSICam is a class used to control the sCMOS Prime BSI Express camera
    %from Teledyne Photometrics
    %Before use, make sure you downloaded the 'pmimaq_2019b' adaptor and
    %registered it as a third party adaptor into the Matlab Image Acquitsition Toolbox
    
    properties (Constant = true)
        AdaptorVersion = 'pmimaq_2019b'; % Do not change, required to identify the caméra
        CameraType = 'PM-Cam 2048x2048'; % Do not change, required to identify the caméra
        SensorWidth = 2048; % Sensor size
        SensorHeight = 2048;
        Authorized_Readout = {'Port0-Speed0-200MHz-11bit-Gain1-Full well','Port0-Speed0-200MHz-11bit-Gain2-Balanced','Port0-Speed0-200MHz-11bit-Gain3-Sensitivity','Port0-Speed1-100MHz-16bit-Gain1-HDR','Port0-Speed1-100MHz-12bit-Gain2-CMS'}
            % -- Highest Frame Rate:
            % 'Port0-Speed0-200MHz-11bit-Gain1-Full well';
            % 'Port0-Speed0-200MHz-11bit-Gain2-Balanced';
            % 'Port0-Speed0-200MHz-11bit-Gain3-Sensitivity';
            % -- Highest dynamic range:
            % 'Port0-Speed1-100MHz-16bit-Gain1-HDR'; 
            % -- Best read noise performance according to user manual
            % 'Port0-Speed1-100MHz-12bit-Gain2-CMS';
        Authorized_Trigger = {'internal','external'};
            % 'internal' : software controlled
            % 'external' : TLL on the TRIG IN input
        Authorized_Exp_Out = {'Line Output','Any Row','First Row','Rolling Shutter'};
        Authorized_CircBuffer = {'ON', 'SNAP', 'SEQ'};
    end
    
    properties (GetAccess = public, SetAccess = public)
        vid; % Created when connecting the camera
        src; % Created when connecting the camera
        SavePath; % Folder with date of the day ("root")
        SaveFolder; % Folder of the acquisition
        SaveName; % Name of the image
        ImageNumber = 0; % Image Number for snapshots
        ImageNumberMany = 0; % Image Number for sequence acquisition
        AcqNumber = 0; % Acquisition Number
        ROIWidth = 2048; % ROI Size
        ROIHeight = 2048;
        ExposureTime = 10; %Exposure Time
        Movie;
        Image;
        IsLiveON = 1;
        ReadoutMode;
    end
    
    methods
        
        %Construct and initialise the camera
        function obj = BSICam() %Constructor
            obj.vid = videoinput(obj.AdaptorVersion, 1, obj.CameraType);
            obj.src = getselectedsource(obj.vid);
            obj.vid.FramesPerTrigger = 1;
            obj.vid.TriggerRepeat = 1;
            %Set default settings
            obj.src.AutoContrast = 'OFF'; % Must be turned off, else, greylevels are rescaled on saved images 
            obj.SetDefaultParameters()
            obj.SetDatePath()
        end
        
        % Set default settings
        function SetDefaultParameters(obj)
            obj.SetExposure(10);
            obj.SetTriggerMode('internal');
            obj.SetReadoutMode('Port0-Speed1-100MHz-16bit-Gain1-HDR');
            obj.SetExpOut('Rolling Shutter');
            obj.SetCircBuffer('ON');
        end

%% Set individual parameters

        % Set Exposure Time in ms
        function SetExposure(obj, ExpoTime)
            obj.src.Exposure = ExpoTime;
            obj.ExposureTime = ExpoTime;
        end
        
        % Set Readout Mode
        function SetReadoutMode(obj, ReadoutMode)
            %Check if ReadoutMode is valid
            isValidString = strcmp(ReadoutMode, obj.Authorized_Readout);
            [~,idx] = find(isValidString == 1);
            if isempty(idx) %Invalid ReadoutMode given
                disp('Invalid Readout Mode, Readout Mode not modified')
            else %Valid ReadoutMode, so update it                
                obj.src.PortSpeedGain = ReadoutMode;
            end
            obj.ReadoutMode = ReadoutMode;
        end

        % Set external trigger mode %Default is 'internal'
        function SetTriggerMode(obj,TriggerMode) 
            if strcmp(TriggerMode,'external')
                triggerconfig(obj.vid, 'hardware', 'Falling edge', 'Extern'); 
            else
                triggerconfig(obj.vid, 'immediate'); 
            end           
        end
        
        %Set EXP_OUT mode (laser synchronisation)
        function SetExpOut(obj,Expose_Out_Mode)
            %Check if Expose_Out_Mode is valid
            isValidString = strcmp(Expose_Out_Mode, obj.Authorized_Exp_Out);
            [~,idx] = find(isValidString == 1);
            if isempty(idx) 
                disp('Invalid EXP_OUT Mode, EXP_OUT Mode not modified')
            else                
                obj.src.ExposeOutMode = Expose_Out_Mode;
            end
        end

        %Set Circular Buffer (laser synchronisation)
        function SetCircBuffer(obj,CircBuffer)
           %Check if Expose_Out_Mode is valid
            isValidString = strcmp(CircBuffer, obj.Authorized_CircBuffer);
            [~,idx] = find(isValidString == 1);
            if isempty(idx) 
                disp('Invalid Circular Buffer Mode, Circular Buffer Mode not modified')
            else      
                obj.src.CircularBufferEnabled = CircBuffer;
            end
        end
        
        %Set ROI
        function SetROICentered(obj,Width,Height)
            deltaX = floor(obj.SensorWidth - Width)/2;
            deltaY = floor(obj.SensorHeight - Height)/2;
            obj.vid.ROIPosition = [deltaX deltaY Width Height];
            obj.ROIWidth = Width;
            obj.ROIHeight = Height;
        end
        
        function SetROICustom(obj,deltaX,deltaY,Width,Height)
            obj.vid.ROIPosition = [deltaX deltaY Width Height];
            obj.ROIWidth = Width;
            obj.ROIHeight = Height;
        end

        
%% Saving functions
        
        %Set Default Save Path
        function SetDatePath(obj)
            % Get current date
            c = clock();
            year = c(1);
            month = c(2);
            day = c(3);
            % Create folder named yyyymmdd/AcquisitionN°
            Folder = strcat(num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'));
            obj.SavePath = fullfile('C:\Users\Manip MOSAIC Loic\DATA_RIM',Folder);
            if ~exist(obj.SavePath)
                mkdir(obj.SavePath)
            end
        end
          
        function SetSaveFolder(obj,Mode,varargin)
            % Mode can be 'Default' or 'Manual'
            % Varargin = Folder in case Mode == 'Manual'            
            if strcmp(Mode,'Manual')
                obj.SaveFolder = fullfile(obj.SavePath,varargin{1});
            else
                obj.AcqNumber = obj.AcqNumber + 1;
                obj.ImageNumber = 0;
                Folder = strcat('Acquisition',num2str(obj.AcqNumber,'%02d'));
                obj.SaveFolder = fullfile(obj.SavePath,Folder);
            end 
            %Create Folder
            if ~exist(obj.SaveFolder)
                mkdir(obj.SaveFolder)
            end
        end         
        
        function SetSaveName(obj,Mode,varargin)
            %Mode can be 'ImageNumber', 'TimeStamp' or 'Manual'
            if strcmp(Mode,'Manual')
                ImageName = strcat(varargin{1},'.tif');
            elseif strcmp(Mode,'TimeStamp')
                c = clock();
                hour = c(4);
                minutes = c(5);
                seconds = fix(c(6));
                milliseconds = fix(1000*c(6))-1000*seconds;
                ImageName = strcat('Image_',num2str(hour,'%02d'),'h',num2str(minutes,'%02d'),'m',num2str(seconds,'%02d'),'s',num2str(milliseconds,'%03d'),'ms','.tif');
            elseif strcmp(Mode,'ImageNumberMany')
                obj.ImageNumberMany = obj.ImageNumberMany + 1;
                ImageName = strcat('Image_',num2str(obj.ImageNumberMany),'.tif');
            else
                obj.ImageNumber = obj.ImageNumber + 1;
                ImageName = strcat('Image_',num2str(obj.ImageNumber),'.tif');
            end
            obj.SaveName = fullfile(obj.SaveFolder,ImageName);
        end
                    
%% Capture 1 image               
        function Capture1(obj)
            obj.SetCircBuffer('SNAP');
            obj.vid.TriggerRepeat = 1;
            start(obj.vid)
            wait(obj.vid,obj.ExposureTime,'logging');
            imwrite(getdata(obj.vid), obj.SaveName);
            stop(obj.vid);
        end
        
%% Capture many images, one by one
        function StartCapture(obj)
            % Tell the camera it will have to acquire many images
            obj.vid.TriggerRepeat = Inf;
            % Each image will be software triggered
            triggerconfig(obj.vid, 'manual');
            % Save video onto RAM, unless asked to write on the disk
            obj.vid.LoggingMode = 'memory';
            obj.SetCircBuffer('ON');
            % Get Camera ready
            start(obj.vid)
        end
        
        function Capture1more(obj)
            trigger(obj.vid);
            % after each capture, the image has to be read to empty memory
        end
        
        function Save1more(obj)
            imwrite(getdata(obj.vid), obj.SaveName);
        end
        
        function Get1more(obj)
            obj.Image = getdata(obj.vid);
        end
        
        function StopCapture(obj)
            stop(obj.vid);
        end
        
%% Capture sequence as fast as Possible        
        function CaptureMany(obj,NumImg)
            %obj.SetSaveFolder('Manual','Test1');
            obj.SetSaveFolder('Default');
            % Set trigger mode to maximmize speed
            obj.vid.LoggingMode = 'memory';
            triggerconfig(obj.vid, 'immediate'); %Start new acquisition as soon as the previous one is finished
            obj.vid.TriggerRepeat = NumImg-1;
            obj.SetCircBuffer('ON');
            
            % Start camera
            start(obj.vid);
            % Wait until the camera tells that acquisition is finished
            wait(obj.vid,NumImg*obj.ExposureTime+10,'logging');
            % Get data back to computer
            obj.Movie = getdata(obj.vid, obj.vid.FramesAvailable);
            stop(obj.vid);
        end
        
        function SaveMany(obj)
            numFrames = size(obj.Movie, 4);
            obj.ImageNumberMany = 0;
            for ii = 1:numFrames
                obj.SetSaveName('ImageNumberMany');
                imwrite(obj.Movie(:,:,:,ii), obj.SaveName);
            end
            clear obj.Movie
        end

%% Release the camera
        function Delete(obj)
            delete(obj)
            clear obj
        end

    end
end

