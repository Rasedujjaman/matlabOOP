function varargout = Gui_exp_setup(varargin)
% GUI_EXP_SETUP MATLAB code for Gui_exp_setup.fig
%      GUI_EXP_SETUP, by itself, creates a new GUI_EXP_SETUP or raises the existing
%      singleton*.
%
%      H = GUI_EXP_SETUP returns the handle to a new GUI_EXP_SETUP or the handle to
%      the existing singleton*.
%
%      GUI_EXP_SETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_EXP_SETUP.M with the given input arguments.
%
%      GUI_EXP_SETUP('Property','Value',...) creates a new GUI_EXP_SETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gui_exp_setup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gui_exp_setup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gui_exp_setup

% Last Modified by GUIDE v2.5 06-Jul-2020 11:48:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gui_exp_setup_OpeningFcn, ...
                   'gui_OutputFcn',  @Gui_exp_setup_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Gui_exp_setup is made visible.
function Gui_exp_setup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gui_exp_setup (see VARARGIN)

% Choose default command line output for Gui_exp_setup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gui_exp_setup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gui_exp_setup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in camera_start.
function camera_start_Callback(hObject, eventdata, handles)
global  hndl imagesize width height stride top left exposuretime run buf2 expo_time_new 
global val_stop snap_id scan_id  voltage_ch0_scan  voltage_ch1_scan sleep_time fourier_id cross_id

% hObject    handle to camera_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % ao_device = analogoutput('mwadlink',0); % to initialize the board as output
% % % % % ch_ao = addchannel(ao_device, [0 1]);   % activate channel#0 and channel#1

ao_device = daq.createSession('dt');
ao_device.addAnalogOutputChannel('DT9853(00)','0', 'Voltage'); % for Ch#0
ao_device.addAnalogOutputChannel('DT9853(00)','1', 'Voltage');  % for Ch#1

%%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 

% % % % % putsample(ao_device, [0, 0])
outputSingleScan(ao_device,[0 0]);

delete (ao_device);
clear ao_device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % global buf2 width height hndl rc
    %disp('Andor SDK3 Live Mode Example');
    [rc] = AT_InitialiseLibrary();
    AT_CheckError(rc);
    [rc,hndl] = AT_Open(0);
    AT_CheckError(rc);
    %disp('Camera initialized');
    [rc] = AT_SetFloat(hndl,'ExposureTime',0.01);
    AT_CheckWarning(rc);
    [rc, expo_time_new] = AT_GetFloat(hndl,'ExposureTime');
    AT_CheckWarning(rc);
   
% %     
% %     width = 2560;
% %     left = 1;
% %     height = 2160;
% %     top = 1;
% %     customized_roi(hndl, height, width, top, left);  % to set the ROI
    
    
    [rc] = AT_SetEnumString(hndl,'CycleMode','Continuous');
    AT_CheckWarning(rc);
    [rc] = AT_SetEnumString(hndl,'TriggerMode','Software');
    AT_CheckWarning(rc);
    [rc] = AT_SetEnumString(hndl,'SimplePreAmpGainControl','16-bit (low noise & high well capacity)');
    AT_CheckWarning(rc);
    [rc] = AT_SetEnumString(hndl,'PixelEncoding','Mono16');
    AT_CheckWarning(rc);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% Here you set the ROI or sometimes called Area of Interest
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rc,imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
AT_CheckWarning(rc);
[rc,height] = AT_GetInt(hndl,'AOIHeight');
AT_CheckWarning(rc);
[rc,width] = AT_GetInt(hndl,'AOIWidth');
AT_CheckWarning(rc);
[rc,stride] = AT_GetInt(hndl,'AOIStride'); 
AT_CheckWarning(rc);

%warndlg('To Abort the acquisition close the image display.','Starting Acquisition')    
disp('Starting acquisition...');
[rc] = AT_Command(hndl,'AcquisitionStart');
AT_CheckWarning(rc);
buf2 = zeros(width,height);
buf2 = buf2';



axes(handles.axes1);
h=imagesc(buf2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% To draw the horizontal and vertical line
% % hold on
% % x = size(buf2,1);
% % y = size(buf2,2);
% % lin_x = linspace(1,x);
% % lin_y = linspace(1,y);
% % 
% % x_mid = linspace(x/2,x/2);
% % y_mid = linspace(y/2,y/2);
% % 
% % plot(y_mid,lin_x,'r','LineWidth',2) % plot the vertical line
% % hold on
% % plot(lin_y, x_mid,'r','LineWidth',2)  % plot the horizontal line
% % hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





axes(handles.axes2);
h2 = imagesc(log10(abs(fftshift(fft2(buf2)))));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ao_device = analogoutput('mwadlink',0); % to initialize the board as output
% % ch_ao = addchannel(ao_device, [0 1]);   % activate channel#0 and channel#1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%% To draw the horizontal and vertical line
% % hold on
% % x = size(buf2,1);
% % y = size(buf2,2);
% % lin_x = linspace(1,x);
% % lin_y = linspace(1,y);
% % 
% % x_mid = linspace(x/2,x/2);
% % y_mid = linspace(y/2,y/2);
% % 
% % plot(y_mid,lin_x) % plot the vertical line
% % hold on
% % plot(lin_y, x_mid)  % plot the horizontal line
% % hold off
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % axes(handles.axes2);
% % h2 = imagesc(log10(abs(fftshift(fft2(buf2)))));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% To draw the horizontal and vertical line
% % % hold on
% % % x = size(buf2,1);
% % % y = size(buf2,2);
% % % lin_x = linspace(1,x);
% % % lin_y = linspace(1,y); 
% % % 
% % % x_mid = linspace(x/2,x/2);
% % % y_mid = linspace(y/2,y/2);
% % % 
% % % plot(y_mid,lin_x) % plot the vertical line
% % % hold on
% % % plot(lin_y, x_mid)  % plot the horizontal line
% % % hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

snap_id = 1;
scan_id = 1;
val_stop = 1;
sleep_time = 0.2; % defaul sleep value (for the galvalo mirror)
fourier_id = 1;  % 1 for the modulus and 2 for angle
cross_id = 2;  % 1 for displaying the cross and 2 for no cross % we want no cross at the startup

set(handles.radiobutton_fourier_modulus,'Value',1); % the default button is modulus
set(handles.radiobutton_cross_no,'Value',1); % the default button is on for the cross (yes)

while true
    [rc] = AT_QueueBuffer(hndl,imagesize);
    %AT_CheckWarning(rc);
    [rc] = AT_Command(hndl,'SoftwareTrigger');
    %AT_CheckWarning(rc);
    [rc,buf] = AT_WaitBuffer(hndl,1000);
    %AT_CheckWarning(rc);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    buf2 = buf2';
    %AT_CheckWarning(rc);
    set(h,'CData',buf2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (fourier_id == 1)
        set(h2,'CData',log10(abs(fftshift(fft2(buf2)))));
    end
    if (fourier_id == 2)
        set(h2,'CData', (angle(fftshift(fft2(buf2)))));
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %set(h2,'CData',log10(abs(fftshift(fft2(buf2)))));
    %set(h2,'CData',fourier);
    drawnow;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% To display the intensity value
max_intensity = max(max(buf2));
avg_intensity = floor(sum(sum(buf2))/(height*width));
set(handles.edit_avg_intensity, 'String', num2str(avg_intensity));
set(handles.edit_max_intensity, 'String', num2str(max_intensity));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% To change the exposure time
    
    [rc,expo_time_curret] = AT_GetFloat(hndl,'ExposureTime');
% %     disp(expo_time_curret);
% %     disp(expo_time_new);
% %     disp('--------');
   % AT_CheckWarning(rc);
    if (expo_time_new ~= expo_time_curret)
%         disp('In exposure function');
        [rc] = AT_SetFloat(hndl,'ExposureTime',expo_time_new);
%        AT_CheckWarning(rc);
        [rc,expo_time_curret1] = AT_GetFloat(hndl,'ExposureTime');
        expo_time_new = expo_time_curret1;
        disp('Exposure times is set properly');
     %   AT_CheckWarning(rc); 
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [rc, new_height] = AT_GetInt(hndl,'AOIHeight');
    [rc, new_width]  = AT_GetInt(hndl,'AOIWidth');
    
    if (height ~= new_height && width ~= new_width)
        [rc] = AT_Command(hndl,'AcquisitionStop');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Set the ROI     
        [rc1] = AT_SetInt(hndl,'AOIWidth',width);
        [rc2] = AT_SetInt(hndl,'AOILeft',left);
        [rc3] = AT_SetInt(hndl,'AOIHeight',height);
        [rc4] = AT_SetInt(hndl,'AOITop',top);

        if any([rc1 rc2 rc3 rc4])
        AT_CheckWarning(rc1);
        AT_CheckWarning(rc2);
        AT_CheckWarning(rc3);
        AT_CheckWarning(rc4);
        elseif (rc1 && rc2 && rc3 && rc4) == 0
        disp('ROI is set properly')
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       [rc] = AT_SetEnumString(hndl,'CycleMode','Continuous');
        AT_CheckWarning(rc);
        [rc] = AT_SetEnumString(hndl,'TriggerMode','Software');
        AT_CheckWarning(rc);
        [rc] = AT_SetEnumString(hndl,'SimplePreAmpGainControl','16-bit (low noise & high well capacity)');
        AT_CheckWarning(rc);
        [rc] = AT_SetEnumString(hndl,'PixelEncoding','Mono16');
        AT_CheckWarning(rc);
        [rc,imagesize] = AT_GetInt(hndl,'ImageSizeBytes');
        AT_CheckWarning(rc);
        [rc,height] = AT_GetInt(hndl,'AOIHeight');
        AT_CheckWarning(rc);
        [rc,width] = AT_GetInt(hndl,'AOIWidth');
        AT_CheckWarning(rc);
        [rc,stride] = AT_GetInt(hndl,'AOIStride'); 
        AT_CheckWarning(rc);
        %warndlg('To Abort the acquisition close the image display.','Starting Acquisition')    
% %         disp('Starting acquisition...');
        [rc] = AT_Command(hndl,'AcquisitionStart');
        AT_CheckWarning(rc);
        buf2 = zeros(width,height);
        buf2 = buf2';

% %         axes(handles.axes1);
% %         h=imagesc(buf2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%% To display the cross (image plane) when we change ROI
        %%% Read the value of cross id from the handle
        
        if (handles.radiobutton_cross_yes.Value == 1)
             cross_id = 1;
        end
        
        if (handles.radiobutton_cross_no.Value == 1)
             cross_id = 2;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        if (cross_id == 1)
            axes(handles.axes1);
            h=imagesc(buf2);
            hold on
            x = size(buf2,1);
            y = size(buf2,2);
            lin_x = linspace(1,x);
            lin_y = linspace(1,y);

            x_mid = linspace(x/2,x/2);
            y_mid = linspace(y/2,y/2);

            plot(y_mid,lin_x,'r','LineWidth',2) % plot the vertical line
            hold on
            plot(lin_y, x_mid,'r', 'LineWidth',2)  % plot the horizontal line
            hold off
            cross_id = 100;
        end
 
%%%%%%%%%%%%%%%% To turn off the cross in the image plane
%%%% As defined earlier  when cross_id is equal to 2 (when you press off
%%%% button ) we just display the content of buf2 in axes handles#1

        if (cross_id == 2)
            axes(handles.axes1);
            h=imagesc(buf2);
            cross_id = 200;
        end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (fourier_id == 1)
            
            axes(handles.axes2);
            h2 = imagesc(log10(abs(fftshift(fft2(buf2)))));
        end
        if (fourier_id == 2)
            axes(handles.axes2);
            h2 = imagesc((angle(fftshift(fft2(buf2)))));
        end
        
        
% %         height = new_height;
% %         width  = new_width;
% %         disp('New ROI');  %%% To check if ROI is set properly or not
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%% To display the cross (image plane)
    if (cross_id == 1)
        axes(handles.axes1);
        h=imagesc(buf2);
        hold on
        x = size(buf2,1);
        y = size(buf2,2);
        lin_x = linspace(1,x);
        lin_y = linspace(1,y);

        x_mid = linspace(x/2,x/2);
        y_mid = linspace(y/2,y/2);

        plot(y_mid,lin_x,'r','LineWidth',2) % plot the vertical line
        hold on
        plot(lin_y, x_mid,'r', 'LineWidth',2)  % plot the horizontal line
        hold off
        cross_id = 100;  % to ensure we enter the this if condition only onces
    end
 
%%%%%%%%%%%%%%%% To turn off the cross in the image plane
%%%% As defined earlier  when cross_id is equal to 2 (when you press off
%%%% button ) we just display the content of buf2 in axes handles#1

    if (cross_id == 2)
        axes(handles.axes1);
        h=imagesc(buf2);
        cross_id = 200;  % to ensure we enter the this if condition only onces
    end


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% For single snapshot
if(snap_id == 33)

    FileName = ['ref',datestr(now,'ddmmyyyyHHMMSS')];
    [rc] = AT_QueueBuffer(hndl,imagesize);
    AT_CheckWarning(rc);
    [rc] = AT_Command(hndl,'SoftwareTrigger');
    AT_CheckWarning(rc);
    [rc,buf] = AT_WaitBuffer(hndl,1000);
    AT_CheckWarning(rc);
    [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
    AT_CheckWarning(rc);
    img_snap = buf2';   
    save( fullfile(FileName),'img_snap');
    %save FileName img_snap_one;
    disp('Snap is taken');
    snap_id = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% For acquisition (multiple snapshoot)
if(scan_id == 233)
    disp('Scaning started.....');
    tic  %%% to calculate the timing for the scaning 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% you load the dac board
% % % % %     ao_device = analogoutput('mwadlink',0); % to initialize the board as output
% % % % %     ch_ao = addchannel(ao_device, [0 1]);   % activate channel#0 and channel#1
    ao_device = daq.createSession('dt');
    ao_device.addAnalogOutputChannel('DT9853(00)','0', 'Voltage');
    ao_device.addAnalogOutputChannel('DT9853(00)','1', 'Voltage');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%% to alocate the momery
     sz_stack = size(voltage_ch0_scan,1);
% %      temp_data = uint16(zeros(size(buf2,1), size(buf2,2)));
% %      disp(size(buf2,1));
% %      disp(size(buf2,2));
     temp_data = uint16(zeros((size(buf2,1)), (size(buf2,2))));
     scan_data = repmat(temp_data, [1, 1, sz_stack]);
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = 1:size(voltage_ch0_scan,1)
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% set the channel voltage
        %%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 

% % % % %         putsample(ao_device, [voltage_ch0_scan(ii), voltage_ch1_scan(ii)]);
        outputSingleScan(ao_device, [voltage_ch0_scan(ii), voltage_ch1_scan(ii)]);
        pause(sleep_time); % sleep time to settle the galvano mirrors
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [rc] = AT_QueueBuffer(hndl,imagesize);
        AT_CheckWarning(rc);
        [rc] = AT_Command(hndl,'SoftwareTrigger');
        AT_CheckWarning(rc);
        [rc,buf] = AT_WaitBuffer(hndl,1000);
        AT_CheckWarning(rc);
        [rc,buf2] = AT_ConvertMono16ToMatrix(buf,height,width,stride);
        AT_CheckWarning(rc);
        set(h,'CData',buf2'); % to run the live at the same time

        scan_data(:,:,ii) = buf2';  % this operation make the acquisition slower (need to modify)
% %         scan_data = buf2';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% To display the intensity value
        max_intensity = max(max(buf2));
        avg_intensity = floor(sum(sum(buf2))/(height*width));
        set(handles.edit_avg_intensity, 'String', num2str(avg_intensity));
        set(handles.edit_max_intensity, 'String', num2str(max_intensity));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    timeElapsed = toc  % to display the total time elapsed 
    FileName = ['scan',datestr(now,'ddmmyyyyHHMMSS')];
    save( fullfile(FileName),'scan_data' )
    clear scan_data; 
    
% % % % %     putsample(ao_device, [0, 0]);
    outputSingleScan(ao_device, [0, 0]);
    delete (ao_device);  % newly added
    clear ao_device   % newly added
    scan_id = 1;
    disp('Scan is finished.....');
% %     timeElapsed = toc  % to display the total time elapsed 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% To stop the live acquisition 
% %     disp(val_stop);
% %     disp('-----------');
    if(val_stop == 133)
        disp('Acquisition complete');
        [rc] = AT_Command(hndl,'AcquisitionStop');
        AT_CheckWarning(rc);
        [rc] = AT_Flush(hndl);
        AT_CheckWarning(rc);
        [rc] = AT_Close(hndl);
        AT_CheckWarning(rc);
        [rc] = AT_FinaliseLibrary();
        AT_CheckWarning(rc);
        disp('Live acquisition finised and camera is shutdown');
% %         clear val_stop;   %%% to set this value 1 to continue the live mode
% %         disp(val_stop);
        break  
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  STOP LIVE CAMERA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on slider movement.
function slider_ch0_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slider_ch0Value = get(handles.slider_ch0, 'Value');
set(handles.text_channel0,'String',num2str(slider_ch0Value));
guidata(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_ch0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_ch1Value = get(handles.slider_ch1, 'Value');
set(handles.text_channel1,'String',num2str(slider_ch1Value));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider_ch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in set_channels_value.
function set_channels_value_Callback(hObject, eventdata, handles)
% hObject    handle to set_channels_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% To set the slider value manually by putting value in the box
%%% For channel#0
sliderValue0 = get(handles.text_channel0,'String');
sliderValue0 = str2num(sliderValue0);
max_val_ch0 = get(handles.slider_ch0,'Max');
min_val_ch0 = get(handles.slider_ch0,'Min');
if(isempty(sliderValue0) || sliderValue0 < min_val_ch0 || sliderValue0 > max_val_ch0)
    set(handles.slider_ch0,'Value',0);
    set(handles.text_channel0,'String','0');
else
    set(handles.slider_ch0,'Value',sliderValue0);
end

%%% For channel#1
sliderValue1 = get(handles.text_channel1,'String');
sliderValue1 = str2num(sliderValue1);
max_val_ch1 = get(handles.slider_ch0,'Max');
min_val_ch1 = get(handles.slider_ch0,'Min');

if(isempty(sliderValue1) || sliderValue1 < min_val_ch1 || sliderValue1 > max_val_ch1)
    set(handles.slider_ch1,'Value',0);
    set(handles.text_channel1,'String','0');
else
    set(handles.slider_ch1,'Value',sliderValue1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% DAQ object and writing to the channel values
voltage_ch0 = get(handles.slider_ch0, 'Value');
voltage_ch1 = get(handles.slider_ch1, 'Value');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ao_device = daq.createSession('dt');
ao_device.addAnalogOutputChannel('DT9853(00)','0', 'Voltage'); % for Ch#0
ao_device.addAnalogOutputChannel('DT9853(00)','1', 'Voltage');  % for Ch#1

%%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 

% % % % % putsample(ao_device, [0, 0])
outputSingleScan(ao_device,[voltage_ch0 voltage_ch1]);

delete (ao_device);
clear ao_device


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % ao_device = analogoutput('mwadlink',0); % to initialize the board as output
% % % % % ch_ao = addchannel(ao_device, [0 1]);   % activate channel#0 and channel#1
% % % % % 
% % % % % %%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 
% % % % % 
% % % % % putsample(ao_device, [voltage_ch0, voltage_ch1])
disp('Daq values are set properly');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function text_channel0_Callback(hObject, eventdata, handles)
% hObject    handle to text_channel0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_channel0 as text
%        str2double(get(hObject,'String')) returns contents of text_channel0 as a double
input = str2num(get(hObject,'string'));
if (isempty(input))
    set(hObject,'String','0')
end


% --- Executes during object creation, after setting all properties.
function text_channel0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_channel0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_channel1_Callback(hObject, eventdata, handles)
% hObject    handle to text_channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_channel1 as text
%        str2double(get(hObject,'String')) returns contents of text_channel1 as a double
input = str2num(get(hObject,'string'));
if (isempty(input))
    set(hObject,'String','0')
end


% --- Executes during object creation, after setting all properties.
function text_channel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ROI.
function popupmenu_ROI_Callback(hObject, eventdata, handles)
%global hndl
% hObject    handle to popupmenu_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ROI contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ROI

global width height top left

switch get(handles.popupmenu_ROI,'Value')
    case 1
        width = 2560;
        left = 1;
        height = 2160;
        top = 1;
  
    case 2
        width = 1776;
        left = 409;
        height = 1760;
        top = 201;
    case 3
        width = 1392;
        left = 601;
        height = 1040;
        top = 561;
        
    case 4
        width = 528;
        left = 1033;
        height = 512;
        top = 825;    
    otherwise
end




% --- Executes during object creation, after setting all properties.
function popupmenu_ROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in exposureTime.
function exposureTime_Callback(hObject, eventdata, handles)
% hObject    handle to exposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global expo_time_new
switch get(handles.exposureTime,'Value')
    case 1
        expo_time_new = 0.01;
    case 2
        expo_time_new = 0.02;
    case 3
        expo_time_new = 0.03;
    case 4
        expo_time_new = 0.04;
    case 5
        expo_time_new = 0.05;
    case 6
        expo_time_new = 0.06;
    case 7
        expo_time_new = 0.07;
    case 8
        expo_time_new = 0.10;
    case 9
        expo_time_new = 0.20;
    case 10
        expo_time_new = 0.50;
    otherwise
end
guidata(hObject,handles);


        






% Hints: contents = cellstr(get(hObject,'String')) returns exposureTime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exposureTime


% --- Executes during object creation, after setting all properties.
function exposureTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop_pushbutton.
function stop_pushbutton_Callback(hObject, eventdata, handles)
global  val_stop
% hObject    handle to stop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%% once the stop button is pressed 'val_stop' will be set to this value
%%%% and will be used by while loop in the live acquisition to stoop the
%%%% camera

val_stop = 133; %%% this value will be used to stop the while loop acquisition
guidata(hObject,handles);


 


% --- Executes on button press in pushbutton_snapshoot.
function pushbutton_snapshoot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_snapshoot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global snap_id
snap_id = 33;
guidata(hObject,handles);


% --- Executes on selection change in popupmenu_scan_pattern.
function popupmenu_scan_pattern_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_scan_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_scan_pattern contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_scan_pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % ao_device = analogoutput('mwadlink',0); % to initialize the board as output
% % % % % ch_ao = addchannel(ao_device, [0 1]);   % activate channel#0 and channel#1
% % % % % 
% % % % % %%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 
% % % % % 
% % % % % putsample(ao_device, [0, 0])



ao_device = daq.createSession('dt');
ao_device.addAnalogOutputChannel('DT9853(00)','0', 'Voltage'); % for Ch#0
ao_device.addAnalogOutputChannel('DT9853(00)','1', 'Voltage');  % for Ch#1

%%%%%%%%%%%%%%%%%%%% Writing the voltage to the output channel 

% % % % % putsample(ao_device, [0, 0])
outputSingleScan(ao_device,[0 0]);

delete (ao_device);
clear ao_device



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 global voltage_ch0_scan voltage_ch1_scan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % These value sets the scan voltage and number of scan for the channels
no_scan_ch0 = 11;  %% number of scan along channel # 0
sval_ch0_min = -1.5; %% minimum scan voltage applied to channel # 0
sval_ch0_max = 1.5; %% maximum scan voltage applied to channel # 0

%%% The corresponding values for channel # 1
no_scan_ch1 = 11;
sval_ch1_min = -2;
sval_ch1_max = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ch0_scan = linspace(sval_ch0_min, sval_ch0_max  , no_scan_ch0);
ch0_step = ch0_scan(end) - ch0_scan(end-1);

ch1_scan = linspace(sval_ch1_max, sval_ch1_min, no_scan_ch1);
ch0_step = ch1_scan(end) - ch1_scan(end-1);


ch0_scan_matrix = zeros(no_scan_ch0, no_scan_ch0);
for ii=1:no_scan_ch0
for jj = 1:no_scan_ch0
    ch0_scan_matrix(jj,ii) = ch0_scan(ii);
end
end

ch1_scan_matrix = zeros(no_scan_ch1, no_scan_ch1);
for ii=1:no_scan_ch1
for jj = 1:no_scan_ch1
    ch1_scan_matrix(ii,jj) = ch1_scan(ii);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch get(handles.popupmenu_scan_pattern,'Value')
    
    case 1
        disp('No Scan type is selected!');
    
    case 2
        
        voltage_ch0_scan = ch0_scan_matrix';
        voltage_ch0_scan = voltage_ch0_scan(:);

        voltage_ch1_scan = ch1_scan_matrix';
        voltage_ch1_scan = voltage_ch1_scan(:);
        disp('Raster scan is selected');
        
    case 3
        %%%%%%%%% For Snake type scan %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        sz_row = size(ch0_scan_matrix,1);
        sz_col = size(ch0_scan_matrix,1);

        for ii = 1:sz_row 
        for jj = 1:sz_col
            if(mod(ii,2) == 0)
                mask0_odd(ii,jj) = 1;
                mask0_even(ii,jj) = 0;
            else
                mask0_odd(ii,jj) = 0;
                mask0_even(ii,jj) = 1;
            end
        end
        end


% % mask0_odd : keeps the elements in the even rows and make zeros the odd rows
% % mask1_even : keeps the elements in the odd rows and make zeros the even rows

        temp_mat1_ch0 = ch0_scan_matrix.*mask0_odd;
        temp_mat2_ch0 = ch0_scan_matrix.*mask0_even;
        temp_mat1_ch0 = fliplr(temp_mat1_ch0);


        temp_mat1_ch1 = ch1_scan_matrix.*mask0_odd;
        temp_mat2_ch1 = ch1_scan_matrix.*mask0_even;
        temp_mat1_ch1 = fliplr(temp_mat1_ch1);


        ch0_scan_matrix = temp_mat1_ch0 + temp_mat2_ch0;
        ch1_scan_matrix = temp_mat1_ch1 + temp_mat2_ch1;
        
        voltage_ch0_scan = ch0_scan_matrix';
        voltage_ch0_scan = voltage_ch0_scan(:);

        voltage_ch1_scan = ch1_scan_matrix';
        voltage_ch1_scan = voltage_ch1_scan(:);
        
        
        disp('Snake motion type pattern is selected');
        
       
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% For circular type scan
    case 4
        
% %         radius = 2.10; % max value of channel#0 
% %         radius = 2.20; % max value of channel#0
% %         radius = 2.25; % max value of channel#0 
        radius = 2.00; % max value of channel#0  %% to make the outer circle closer to the numerical edge
        no_circle = 5;
        r_step = radius/no_circle;
        r = radius:-r_step:0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Delet this part
        r(4) = 0.50;
        r(5) = 0.30;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        th_outmost = 0:10:350;
        th_inner1  = 0:10:350;
        th_inner2  = 0:15:345;
        th_inner3  = 0:20:340;
        th_inner4  = 0:30:330;
        th_inmost  = 0;
        
        sz_voltage = size(th_outmost,2)+size(th_inner1,2)+ size(th_inner2,2)...
            +size(th_inner3,2)+size(th_inner4,2)+size(th_inmost,2);
        
        voltage_ch0_scan = zeros(1, sz_voltage);
        voltage_ch1_scan = zeros(1, sz_voltage);
        
        for ii= 1:size(th_outmost,2)
            temp = th_outmost(ii);
            volt_th_outmost_ch0(ii) = r(1)*sind(temp);
            volt_th_outmost_ch1(ii) = r(1)*sqrt(1.7777)*cosd(temp);
            
        end
            
        for ii= 1:size(th_inner1,2)
            temp = th_inner1(ii);
            volt_th_inner1_ch0(ii) = r(2)*sind(temp);
            volt_th_inner1_ch1(ii) = r(2)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        for ii= 1:size(th_inner2,2)
            temp = th_inner2(ii);
            volt_th_inner2_ch0(ii) = r(3)*sind(temp);
            volt_th_inner2_ch1(ii) = r(3)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        for ii= 1:size(th_inner3,2)
            temp = th_inner3(ii);
            volt_th_inner3_ch0(ii) = r(4)*sind(temp);
            volt_th_inner3_ch1(ii) = r(4)*sqrt(1.7777)*cosd(temp);
            
        end
        
        for ii= 1:size(th_inner4,2)
            temp = th_inner4(ii);
            volt_th_inner4_ch0(ii) = r(5)*sind(temp);
            volt_th_inner4_ch1(ii) = r(5)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        for ii= 1:size(th_inmost,2)
            temp = th_inmost(ii);
            volt_th_inmost_ch0(ii) = r(6)*sind(temp);
            volt_th_inmost_ch1(ii) = r(6)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        
        
        volt_ch0 = [volt_th_outmost_ch0, volt_th_inner1_ch0, volt_th_inner2_ch0, volt_th_inner3_ch0, ...
            volt_th_inner4_ch0, volt_th_inmost_ch0];
        
        volt_ch1 = [volt_th_outmost_ch1, volt_th_inner1_ch1, volt_th_inner2_ch1, volt_th_inner3_ch1, ...
            volt_th_inner4_ch1, volt_th_inmost_ch1];
        
        
% %         voltage_ch0_scan = volt_ch0; %% the original
% %         voltage_ch1_scan = volt_ch1;

        voltage_ch0_scan = volt_ch0  + 0.15;  % % this 0.15 volt is applied to shift the specular globally to the right 
                                                % % (+x direction)
                                               
        voltage_ch1_scan = volt_ch1; 
        
        voltage_ch0_scan = voltage_ch0_scan(:);
        voltage_ch1_scan = voltage_ch1_scan(:);
        
% %         sz_ch0 = size(voltage_ch0_scan,1);
       
        disp('Circular pattern is selected');
% %         disp(sz_ch0)
% %         disp(voltage_ch0_scan)

        



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% For Spiral type scan
    case 5
        
        radius = 2.25; % max value of channel#0 
        no_spiral = 5; % the number of spiral

        a = 0.0012; % constant to control the values of each spiral


        th_inner5  =  0:5:360;
        th_inner4  = 0:10:360;
        th_inner3  = 0:15:360;
        th_inner2  = 0:20:360;
        th_inner1  = 0:30:360;


        sz_voltage = size(th_inner1,2)+size(th_inner2,2)+ size(th_inner3,2)...
                +size(th_inner4,2)+size(th_inner5,2);
            
        voltage_ch0_scan = zeros(1, sz_voltage);
        voltage_ch1_scan = zeros(1, sz_voltage);



        x_old = 0;
 
        for ii = 1:no_spiral

            th_string =  ['th_inner',num2str(ii)];

            theta_temp = eval(th_string , int2str(ii));

            r_temp =  a*theta_temp + x_old;

            x = r_temp.*cosd(theta_temp);
            y = sqrt(1.7777)*r_temp.*sind(theta_temp);

            mm{ii} = x;
            nn{ii} = y;
            x_old = x(end);

        end

        volt_ch0 =  [mm{1} mm{2} mm{3} mm{4} mm{5}];
        volt_ch1 =  [nn{1} nn{2} nn{3} nn{4} nn{5}];

        voltage_ch0_scan = volt_ch0(:);
        voltage_ch1_scan = volt_ch1(:);
        
        disp('Spiral pattern is selected');
% %         disp(voltage_ch0_scan)
%         disp(voltage_ch1_scan)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function popupmenu_scan_pattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_scan_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_scan.
function pushbutton_scan_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global scan_id
scan_id = 233;
guidata(hObject,handles);


% --- Executes on selection change in popupmenu_sleep_time.
function popupmenu_sleep_time_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_sleep_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_sleep_time contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_sleep_time
global sleep_time
switch get(handles.popupmenu_sleep_time,'Value')
    case 1
        disp('No sleep time is set');
    case 2
        sleep_time = 0;
        disp('Sleep time is set correctly');
    case 3
        sleep_time = 0.01;
        disp('Sleep time is set correctly');
    case 4
        sleep_time = 0.02;
        disp('Sleep time is set correctly');
    case 5
        sleep_time = 0.05;
        disp('Sleep time is set correctly');
    case 6
        sleep_time = 0.10;
        disp('Sleep time is set correctly');
    case 7
        sleep_time = 0.15;
        disp('Sleep time is set correctly');
    case 8
        sleep_time = 0.20;
        disp('Sleep time is set correctly');
    case 9
        sleep_time = 0.30;
        disp('Sleep time is set correctly');
    otherwise
end
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function popupmenu_sleep_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_sleep_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_avg_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_avg_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_avg_intensity as text
%        str2double(get(hObject,'String')) returns contents of edit_avg_intensity as a double


% --- Executes during object creation, after setting all properties.
function edit_avg_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_avg_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max_intensity as text
%        str2double(get(hObject,'String')) returns contents of edit_max_intensity as a double




% --- Executes during object creation, after setting all properties.
function edit_max_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_fourier_modulus.
function radiobutton_fourier_modulus_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_fourier_modulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_fourier_modulus
global fourier_id
% Hint: get(hObject,'Value') returns toggle state of radiobutton_fourier_phase
if (handles.radiobutton_fourier_modulus.Value == 1) 
    fourier_id = 1;
    set(handles.radiobutton_fourier_phase,'Value',0);
end
guidata(hObject,handles);


% --- Executes on button press in radiobutton_fourier_phase.
function radiobutton_fourier_phase_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_fourier_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fourier_id
% Hint: get(hObject,'Value') returns toggle state of radiobutton_fourier_phase
if (handles.radiobutton_fourier_phase.Value == 1) 
    fourier_id = 2;
    set(handles.radiobutton_fourier_modulus,'Value',0);
end
guidata(hObject,handles);


% --- Executes on button press in radiobutton_cross_yes.
function radiobutton_cross_yes_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cross_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cross_yes
global cross_id
% Hint: get(hObject,'Value') returns toggle state of radiobutton_fourier_phase
if (handles.radiobutton_cross_yes.Value == 1) 
    cross_id = 1;
    set(handles.radiobutton_cross_no,'Value',0);
end
guidata(hObject,handles);





% --- Executes on button press in radiobutton_cross_no.
function radiobutton_cross_no_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_cross_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_cross_no
global cross_id
% Hint: get(hObject,'Value') returns toggle state of radiobutton_fourier_phase
if (handles.radiobutton_cross_no.Value == 1) 
    cross_id = 2;
    set(handles.radiobutton_cross_yes,'Value',0);
end
guidata(hObject,handles);
