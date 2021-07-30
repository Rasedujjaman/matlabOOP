classdef E545 < handle
    %E545 is a class used to control the E545 piezo controller from Physik
    %Instrumente. It is used to control the X-Y-Z piezo P-545 
    % Controller name is E545, but for PI, it is detected as a E-517
    % Servo switches on the controler must be set to OFF
    % Axis 1 (named 'A' by controler) is X, 2 (B) is Y, 3 (C) is Z
    
    properties (Constant = true)
        StageType = 'E-517';                    % A vérifier
        ControllerSerialNumber = '0113017440';       % A vérifier
        AxisX = 'A';                                % A vérifier
        AxisY = 'B';
        AxisZ = 'C';
    end
    
    properties (GetAccess = public, SetAccess = public)
        Controller;
        Toolbox;
        XRange = [0, 200];
        YRange = [0, 200];
        ZRange = [0, 200];       
        CurPos = [100, 100, 100];
        Precision = 0.01;
        Velocity = [1, 1, 1];
        MaxVelocity = [1, 1, 1];    %Error when willing to read the value
    end
    
    properties(Dependent)
        Ranges
    end
    
    methods
        
        % Construct and initialise the Z piezo
        function obj = E545() %Constructor
            % Load PI MATLAB Driver GCS2
            if(~isdeployed) % Determine whether code is running in deployed or MATLAB mode
                addpath (getenv ('PI_MATLAB_DRIVER'))
            end
            
            % Load PI_GCS_Controller if not already loaded
            if isempty(obj.Controller)
                obj.Controller = PI_GCS_Controller();
            end

            % Create the Toolbox (class containing all the PI functions)
            obj.Toolbox = obj.Controller.ConnectUSB(obj.ControllerSerialNumber);         
            % Built-in PI functions have to be called using obj.toolbox.
            % Functions defined in this class have to be called using obj.
       
            % Initialize controller 
            obj.Toolbox = obj.Toolbox.InitializeController();
            % Start Motor
            obj.MotorSwitch('X',1);
            obj.MotorSwitch('Y',1);
            obj.MotorSwitch('Z',1);
            % Get Min and Max position
            obj.XRange = [obj.Toolbox.qTMN(obj.AxisX), obj.Toolbox.qTMX(obj.AxisX)];
            obj.YRange = [obj.Toolbox.qTMN(obj.AxisY), obj.Toolbox.qTMX(obj.AxisY)];
            obj.ZRange = [obj.Toolbox.qTMN(obj.AxisZ), obj.Toolbox.qTMX(obj.AxisZ)];
            % Get Current Position
            obj.CurPos = [obj.Toolbox.qPOS(obj.AxisX), obj.Toolbox.qPOS(obj.AxisY), obj.Toolbox.qPOS(obj.AxisZ)];
            % Get Max Velocity
            %obj.MaxVelocity = [obj.Toolbox.qSPA(obj.AxisX, 10), obj.Toolbox.qSPA(obj.AxisY, 10), obj.Toolbox.qSPA(obj.AxisZ, 10)];
            % Get Current Velocity
            obj.Velocity = [obj.Toolbox.qVEL(obj.AxisX), obj.Toolbox.qVEL(obj.AxisY), obj.Toolbox.qVEL(obj.AxisZ)];
        end

        % Update Ranges
        function val=get.Ranges(obj)
            val={obj.XRange, obj.YRange, obj.ZRange};
        end
        
        % Convert Axis letter into number
        function [AxisName,AxisNumber] = ConvertAxis(obj, Axis)
            if Axis == 'X'
                AxisNumber = 1;
                AxisName = obj.AxisX;
            elseif Axis == 'Y'
                AxisNumber = 2;
                AxisName = obj.AxisY;
            elseif Axis == 'Z'
                AxisNumber = 3;
                AxisName = obj.AxisZ;
            else
                disp('Wrong Identifier for Piezo Axis');
            end
        end
        
        
        % Start/Stop the motor
        function MotorSwitch(obj, Axis, state)
            % state 0 = motor OFF, state 1 = motor ON
            % Convert Axis into it's code number
            [AxisName,AxisNumber] = obj.ConvertAxis(Axis);
            obj.Toolbox.SVO(AxisName, state);
        end
        
        
        % Move piezo to desired position
        function Move(obj, Axis, Mode, varargin)
            %mode can be 'Absolute', 'Relative' or 'Home'
            %Default is 'Absolute' 
            %varargin == Position
            
            % Convert Axis into it's code number
            [AxisName,AxisNumber] = obj.ConvertAxis(Axis);
            
            %Update current position
            obj.CurPos(AxisNumber) = obj.Toolbox.qPOS(AxisName);
            
            if strcmp(Mode, 'Relative')
                TargetPos = obj.CurPos(AxisNumber) + varargin{1};
            elseif strcmp(Mode, 'Home')
                % TargetPos = Min Position of axis + half the full range of axis
                TargetPos = obj.Ranges{AxisNumber}(1) + (obj.Ranges{AxisNumber}(2)-obj.Ranges{AxisNumber}(1))/2;
            else %by default, 'absolute'
                TargetPos = varargin{1};
            end
                
            % Check that target position is within the accessible range
            % Else move to maximum allowed position and display error
            if TargetPos > obj.Ranges{AxisNumber}(2)
                TargetPos = obj.Ranges{AxisNumber}(2);
                disp('Piezo Z reached upper limit')
            elseif TargetPos < obj.Ranges{AxisNumber}(1)
                TargetPos = obj.Ranges{AxisNumber}(1);
                disp('Piezo Z reached lower limit')
            end
            % Move the piezo
            obj.Toolbox.MOV(AxisName, TargetPos);
            while(0 ~= obj.Toolbox.IsMoving(AxisName))
                pause(0.1);
            end
            %while abs(obj.Toolbox.qPOS(AxisName) - TargetPos) > obj.Precision
            %    pause (0.05)
            %end
            %Update current position 
            GetPosition(obj,Axis);    
        end

        
        %Move the stage in its middle position
        function Home(obj, Axis)
            Move(obj, Axis, 'Home')
        end

        
        % Get Current Position
        function Position = GetPosition(obj, Axis)
            [AxisName,AxisNumber] = obj.ConvertAxis(Axis);
            obj.CurPos(AxisNumber) = obj.Toolbox.qPOS(AxisName);
            Position = obj.CurPos(AxisNumber);
        end
        
        
        % Get Max Velocity
        function MaxVelocity = GetMaxVelocity(obj, Axis)
            [AxisName,AxisNumber] = obj.ConvertAxis(Axis);
            % maximum Velocity is parameter 10 in the qSPA fonction
            obj.MaxVelocity(AxisNumber) = obj.Toolbox.qSPA(AxisName,10);
            MaxVelocity = obj.MaxVelocity(AxisNumber);
        end
 
        
        % Get Velocity
        function Velocity = GetVelocity(obj, Axis)
            [AxisName,AxisNumber] = obj.ConvertAxis(Axis);
            obj.Velocity(AxisNumber) = obj.Toolbox.qVEL(AxisName);
            Velocity = obj.Velocity(AxisNumber);
        end
        
        % Set Velocity
        function SetVelocity(obj, Axis, Velocity)
            [AxisName,AxisNumber] = obj.ConvertAxis(Axis);
            obj.Toolbox.VEL(AxisName, Velocity);
            pause(0.1);
            obj.Velocity(AxisNumber) = obj.Toolbox.qVEL(AxisName);
        end
        
        
        % Release the Z piezo
        function Delete(obj)
            % Stop the servo motor
            obj.MotorSwitch('X',0);
            obj.MotorSwitch('Y',0);
            obj.MotorSwitch('Z',0);
            % Disconnect controller
            obj.Toolbox.CloseConnection ();
        end        
        
    end
end

