classdef StandaMotor < handle
    %StandaMotor Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        device_names
        device_id
        devices_count
    end
    
    methods
        %%% The constructor (load the library files and necessary dll files
        function obj = StandaMotor()
            [~,maxArraySize]=computer;
            is64bit = maxArraySize > 2^31;
            if (ispc)
                if (is64bit)
                        disp('Using 64-bit version');
                else
                        disp('Using 32-bit version');
                end
            elseif ismac
                disp('Using mac version')
            elseif isunix
                disp('Using unix version, check your compilers')
            end

            if not(libisloaded('libximc'))
                disp('Loading library')
                if ispc
                    addpath(fullfile(pwd,'/headerAndFunctionsMotor/ximc/win64/wrappers/matlab/'));
                    if (is64bit)
                            addpath(fullfile(pwd,'/headerAndFunctionsMotor/ximc/win64/'));
                            [notfound,warnings] = loadlibrary('libximc.dll', @ximcm)
                    else
                            addpath(fullfile(pwd,'/headerAndFunctionsMotor/ximc/win32/'));
                            [notfound, warnings] = loadlibrary('libximc.dll', 'ximcm.h', 'addheader', 'ximc.h')
                    end
                elseif ismac
                    addpath(fullfile(pwd,'/headerAndFunctionsMotor/ximc/'));
                    [notfound, warnings] = loadlibrary('libximc.framework/libximc', 'ximcm.h', 'mfilename', 'ximcm.m', 'includepath', 'libximc.framework/Versions/Current/Headers', 'addheader', 'ximc.h')
                elseif isunix
                    [notfound, warnings] = loadlibrary('libximc.so', 'ximcm.h', 'addheader', 'ximc.h')
                end
            end

            % Set bindy (network) keyfile. Must be called before any call to "enumerate_devices" or "open_device" if you
            % wish to use network-attached controllers. Accepts both absolute and relative paths, relative paths are resolved
            % relative to the process working directory. If you do not need network devices then "set_bindy_key" is optional.

             calllib('libximc','set_bindy_key', fullfile(pwd,'/headerAndFunctionsMotor/ximc/win32/keyfile.sqlite'))
            
            
            % %% add the path to load the built in matlab functions provided by Standa
             addpath(fullfile(pwd,'headerAndFunctionsMotor/builtInMotorFunctions/'));
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Get the devices names
        function obj = getDeviceNames(obj)
            if obj.devices_count == 0
                disp('No devices found')
                return
            end
            for i=1:obj.devices_count
                disp(['Found device: ', obj.device_names{1,i}]);
            end

        end
        
        %%% Get the devices ids
        function obj = getDevicesId(obj)
            for ii = 1:obj.devices_count
% %             obj.device_id(ii) = calllib('libximc','open_device', obj.device_names{ii});
            disp(['ID of device [',num2str(ii),'] = ', num2str(obj.device_id(ii))]);
            end
        end
        
        
        %%% Initialize the motors
        function obj = initializeDevices(obj)
            probe_flags = 1 + 4; % ENUMERATE_PROBE and ENUMERATE_NETWORK flags used
            enum_hints = 'addr=192.168.1.1,172.16.2.3';
            % enum_hints = 'addr='; % Use this hint string for broadcast enumeration

            obj.device_names = ximc_enumerate_devices_wrap(probe_flags, enum_hints);
            obj.devices_count = size(obj.device_names,2);
            if obj.devices_count == 0
                disp('No devices found')
                return
            end
            for i=1:obj.devices_count
                disp(['Found device: ', obj.device_names{1,i}]);
            end
            
            for ii = 1:obj.devices_count
            obj.device_id(ii) = calllib('libximc','open_device', obj.device_names{ii});
% %             disp(['Using device id ', num2str(obj.device_id)]);
            end
            disp('Devices are initialized');
        end
        
        
        %%%% Relative rotation of devices
        function obj = rotationRelative(obj, degres, motor_id, clockwise)

            if nargin == 3
                clockwise = true;
            else
                clockwise = false;
            end
            
            if nargin == 2
                motor_id = obj.device_id(2);
                clockwise = true;
            end

            state_rot = ximc_get_status(motor_id);
            current_position = state_rot.CurPosition;
            
            step = (600/360)*degres;  %% one full rotation is 600 steps
            
            if clockwise
                calllib('libximc','command_move', motor_id,current_position+step,0);
            else
                calllib('libximc','command_move', motor_id,current_position-step,0);

            end
        end
        
        
        function obj = goHome(obj)
             for ii = 1:obj.devices_count
                calllib('libximc','command_move',  obj.device_id(ii), 0 ,0);   %% set the motor position at zero (home position)
            end
        end
        
        
        %%% Absolute rotation of the motor
        function obj = rotationAbsolute(obj, degres)
             step = (600/360)*degres;  %% one full rotation is 600 steps
             
             motor_id = obj.device_id(2);
             calllib('libximc','command_move', motor_id,step,0);
        end
        
        
        %%%% Set the motor speed
        
        function obj = setRotationSpeed(obj, speed, motor_id)
             if nargin == 2
                motor_id = obj.device_id(2);
             end

            speedinstep = 0.8*speed;
            ximc_set_speed(motor_id, speedinstep, 0);

        end
        
        % % % Close the devices
        
        function obj = closeDevices(obj)
            for ii = 1:obj.devices_count
                device_id_ptr(ii) = libpointer('int32Ptr', obj.device_id(ii));
                calllib('libximc','command_move',  obj.device_id(ii), 0 ,0);   %% set the motor position at zero (home position)
                calllib('libximc','close_device', device_id_ptr(ii));
                disp(['Device[', num2str(ii),'] is are closed']);
            end
        end
        
        
        
        
    end
end

