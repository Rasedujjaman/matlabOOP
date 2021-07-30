
%% class definition file for the Dac object

classdef Dac
    % The Dac class will be used to instantiate object for the dac to control the galvalo mirror 
   
    
    
    
    
    properties (Access = private) 
        channelX       %%  pin number where the x channel of Galvano mirro will be connected
        channelY       %%  pin number where the y channel of Galvano mirror will be connected
        ao_device      %% This holds the dca device 
        
    end
    
    properties (Access = public)
        voltChannelX = 0   %% voltage to the channelX (default voltage is set to zero)
        voltChannelY = 0   %% voltage to the channelY (default voltage is set to zero)
    end
    
    methods
        
        %% The constructor 
        function obj = Dac(inputArg1,inputArg2)
            % Dac Construct an instance of this class
            %  
%            
            if nargin == 2
                obj.channelX = inputArg1;
                obj.channelY = inputArg2;
                obj.ao_device = daq.createSession('dt');
                obj.ao_device.addAnalogOutputChannel('DT9853(00)',num2str(obj.channelX), 'Voltage');  % for Ch#0
                obj.ao_device.addAnalogOutputChannel('DT9853(00)',num2str(obj.channelY), 'Voltage');  % for Ch#1
                
            else
                obj.channelX = 0;  % default setup for channel X
                obj.channelY = 1;  % default setup for channel Y
                obj.ao_device = daq.createSession('dt');
                obj.ao_device.addAnalogOutputChannel('DT9853(00)',num2str(obj.channelX), 'Voltage');  % for Ch#0
                obj.ao_device.addAnalogOutputChannel('DT9853(00)',num2str(obj.channelY), 'Voltage');  % for Ch#1
            end
        end
        
        

        %%% Method to set the channel voltage individually
        
        function  obj = set.voltChannelX(obj, voltX)
            obj.voltChannelX = voltX;
        end
        
         
        function  obj = set.voltChannelY(obj, voltY)
            obj.voltChannelY = voltY;
        end
       
        
        %%
        %%% put the voltage to the output channel (this function is
        %%% overloaded 
         putVoltage(obj, voltX, voltY);  %% function prototype for supplying voltage
      
         
         
        %% Go to zero position
        obj = goHome(obj);   %% function prototype to set both the channel voltage at zero
            
        %% Close the Dac 
         closeDevices(obj);  %% function prototype to close the Dac
 
        
    end
end

