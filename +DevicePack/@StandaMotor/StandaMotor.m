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
        %%% and built in functions provided by the vendor
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

          
            
             calllib('libximc','set_bindy_key', fullfile(pwd,'/headerAndFunctionsMotor/ximc/win32/keyfile.sqlite'))
            
            
            % %% add the path to load the built in matlab functions provided by Standa
             addpath(fullfile(pwd,'headerAndFunctionsMotor/builtInMotorFunctions/'));
            
        end 
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Get the devices names
        obj = getDeviceNames(obj);  %% function prototype to return the name of the devices
   
        
        
        %%% Get the devices IDS
        obj = getDevicesId(obj);  %% function prototype to return the devices IDs

        
        %%% Initialize the motors
        obj = initializeDevices(obj);  %% function prototype to initialize the motor

        
        %%%% Relative rotation of devices
        obj = rotationRelative(obj, degres, motor_id, clockwise);  %% function prototype


        
        
        %%% Function to set the motor at home (where it was when
        %%% initialized)
        obj = goHome(obj);

        
        %%% Absolute rotation of the motor
        obj = rotationAbsolute(obj, degres); %% function prototype for absolute rotation

        %%%% Set the motor speed
        obj = setRotationSpeed(obj, speed, motor_id); %% function signature to set the speed of the motor
        
% % % % % % Close the devices
       closeDevices(obj);   %% function signature to close the motor

        
        
        
        
    end
end

