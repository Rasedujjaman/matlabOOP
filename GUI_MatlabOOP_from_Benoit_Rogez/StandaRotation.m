classdef StandaRotation < handle
    % Class to control the diffuser.
    % Requires the ximc package, which can be downloaded here: http://files.xisupport.com/Software.en.html
    % Help on functions can be found here: https://libximc.xisupport.com/doc-en/ximc_8h.html#a690365488df653ddbf85e0726782e813

    properties (Constant = true)
        DegreeToStep = 100/60; %100 steps correspond to a rotation of about 60 degrees
        Port = 'COM7';
        %DiffuserPosition = 1;   % 1 if plugged on the left controller, 2 if plugged on the right controller 
    end
    
    properties (GetAccess = public, SetAccess = public)
        device_id
    end
    
            
    methods
        %Construct and initialise the diffuser
        function obj = StandaRotation() %Constructor
            % Load Libraries
            if not(libisloaded('libximc'))
                disp('Loading library')
                addpath(fullfile(pwd,'ximc_Diffuser/win64/wrappers/matlab/'));
                addpath(fullfile(pwd,'ximc_Diffuser/win64/'));
                loadlibrary('libximc.dll', @ximcm);
                calllib('libximc','set_bindy_key', 'ximc_Diffuser/win32/keyfile.sqlite');
            end
            
            % Get connected devices. As the documentation says, this is an
            % opaque pointer, so do not edit.
            dev_enum = calllib('libximc', 'enumerate_devices', 5, 'addr=192.168.1.1,172.16.2.3');
            names_count = calllib('libximc','get_device_count', dev_enum);
            names_array = cell(1,names_count);
            for i=1:names_count
                names_array{1,i} = calllib('libximc','get_device_name', dev_enum, i-1);
                DiffuserPosition = 1; %COM7 should be position 1
                if contains(names_array{1,i}, obj.Port)
                    DiffuserPosition = i;
                end
            end
            calllib('libximc','free_enumerate_devices', dev_enum);
            devices_count = size(names_array,2);
            if devices_count == 0
                disp('No devices found')
                return
            end            
            % Connect to diffuser
            device_name = names_array{1,DiffuserPosition};
            obj.device_id = calllib('libximc','open_device', device_name);
            
            % Step microstep mode to full step.
            % we need to init a struct with any real field from the header.
            dummy_struct = struct('MicrostepMode',0);
            parg_struct = libpointer('engine_settings_t', dummy_struct);
            % read current engine settings from motor
            [result, engine_settings] = calllib('libximc','get_engine_settings', obj.device_id, parg_struct);
            clear parg_struct
            if result ~= 0
                disp(['Command GetEngineSettings failed with code', num2str(result)]);
            end
            engine_settings.MicrostepMode = 1;
            result = calllib('libximc', 'set_engine_settings', obj.device_id, engine_settings);
            if result ~= 0
                disp(['Command Microstep failed with code', num2str(result)]);
            end            
            % Set current position to 0
            calllib('libximc','command_zero', obj.device_id);
        end
        
        %% Velocity
        % Get Move Settings (velocity, acceleration, deceleration,...)
        function [move_settings] = GetMoveSettings(obj)
            % we need to init a struct with any real field from the header.
            dummy_struct = struct('Speed',0);
            parg_struct = libpointer('move_settings_t', dummy_struct);
            % read current engine settings from motor
            [result, move_settings] = calllib('libximc','get_move_settings', obj.device_id, parg_struct);
            clear parg_struct
            if result ~= 0
                disp(['Command GetMoveSettings failed with code', num2str(result)]);
                move_settings = 0;
            end
        end
        
        % Get Velocity
        function Velocity = GetVelocity(obj)
            % First need to get the move settings, then extract the velocity
            [move_settings] = GetMoveSettings(obj);
            Velocity = move_settings.Speed;
        end
        
        % Set Velocity
        function SetVelocity(obj,Velocity)
            % First need to get the move settings to get the good structure
            [move_settings] = GetMoveSettings(obj);
            % Then, replace velocity with the desired value
            move_settings.Speed = Velocity;
            calllib('libximc', 'set_move_settings', obj.device_id, move_settings);
        end
        
        %% Position
        % Get status
        function [status] = GetStatus(obj)
            dummy_struct = struct('Flags',999);
            parg_struct = libpointer('status_t', dummy_struct);
            [result, status] = calllib('libximc','get_status', obj.device_id, parg_struct);
            clear parg_struct
            if result ~= 0
                disp(['Command GetStatus failed with code', num2str(result)]);
                res_struct = 0;
            end
        end
        
        % Get Position
        function Position = GetPosition(obj)
            [status] = obj.GetStatus();
            Position = status.CurPosition;
        end
        
        % Set Position, absolute 
        function MoveTo(obj,TargetPosition)
            calllib('libximc','command_move', obj.device_id, TargetPosition, 0);
        end
        
        %Set Position, relative, Angle in degree
        function Rotate(obj,AngleDegree,Direction)
            Position = obj.GetPosition();
            AngleSteps = floor(AngleDegree * obj.DegreeToStep);
            if strcmp(Direction, 'CounterClockwise')
                TargetPosition = Position - AngleSteps;
            else
                TargetPosition = Position + AngleSteps;
            end
            calllib('libximc','command_move', obj.device_id, TargetPosition, 0);
        end
        
        %Continuous rotation
        function RotateContinuous(obj,Direction)
            if strcmp(Direction, 'CounterClockwise')
                calllib('libximc','command_left', obj.device_id);
            else
                calllib('libximc','command_right', obj.device_id);
            end
        end

        %Stop rotation
        function StopRotation(obj)
            calllib('libximc','command_sstp', obj.device_id);
        end
        
        
        %Release diffuser
        function Delete(obj)
            device_id_ptr = libpointer('int32Ptr', obj.device_id);
            calllib('libximc','close_device', device_id_ptr);
            disp('Diffuser Deleted');
        end

    end
    
end
