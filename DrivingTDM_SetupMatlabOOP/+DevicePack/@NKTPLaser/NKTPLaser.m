
classdef NKTPLaser < handle
    %NKTPLASER Summary of this class goes here
    %   Detailed explanation goes here
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% The properties of the class
    properties(Constant = true)
        %% Identification parameres of the devices
        %%% These values are device specific and found in the SDK manual
        
        moduleTypeLaserSource = 96; % in hex (60h) For SuperK EXT-12 : as found in the SDK folder
        moduleTypeFilter = 104;  % in hex (68h) for SuperK Varia: as found in the SDK 
        
        
        addressModuleTypeLaserSource = 15;   % (in hex (0Fh)): from the SDK manual of NKT photonics
        addressModuleTypeFilter = 16;  % See the address in the SuperK Varia module( in our filter module the 
                                % arrow is pointed to (00h) and according
                                % to the instructios from the SKD module we
                                % have to add (10h). So in decimal it is 16
    
        
        
        %%
        %%% Necessary register id and values for to control the laser
        %%% source : as found in the SDK manual
        regID_ONandOFF = 48;    %% register id  for ON/OFF operation of the LASER
        regID_PowerLevel = 55;  %% register id for changing the power level
        valueTurnON_Laser = 3;  %% value to turn ON the laser source
        valueTurnOFF_Laser = 0; %% value to turn OFF the laser source
        
        %% 
        %%% Necessary register id and values for to control 
        %%% the SuperK Varia: as found in the SDK manual
        regID_SWP = 51;  %% Short wave pass filter setpoint register ID (in hex 33h)
        regID_LWP = 52;  %% Long wave pass filter setpoint register ID (in hex 34h )
        
        %%
        %%% The power level of the LASER
        %%%  % % allowed value (0: lowest level to 100: highest level)
        minPowerLevel = 0;   %% the minimum value for the power level                    
        maxPowerLevel = 100; 
        %% The filter output parameters
        minBandWidth = 10;   %% 10 nano meters
        maxBandWidth = 100;  %% 100 nano meters
        minWavelength = 400; %% The filter output of the SuperK Varia can not go below 400 nm
        maxWavelength = 840; %% The filter output of the SuperK Varia can not go beyond 840 nm
        
        %% The default parameters of the LASER output beam
        defaultPowerLevel = 5;   %% 5 percent as displayed when the laser is turned on
        defaultWaveLength = 475; %% It is a free choice value of wavelength 475nm
        defaultBandWidth = 10;   %% It is the default bandwidth. 
    end
    
    
    properties (Access = private)
        
        powerLevel = 5;    %% present level of laser power(initial value is set to default) 
        bandWidth  = 10;   %% the present spectral bandwidth (initial value is set to default) 
        
        
    end
    
    properties (Access = public)
        portName;          %% The COM port where the module is conneced
        isLaserON = 0;  %% This will indicates the status of the LASER
                        %%%  isLaserON = 0: Laser is in OFF state
                        %%%  isLaserON = 1: Laser is in ON state
                        
        waveLength = 475;  %% the present wavelength of the LASER (initial value is set to default) 
        %%% The color Triplet
        R
        G
        B
        
    end
   
    
    
    %% The methods associated to the class NKTPLaser
    methods
        function obj = NKTPLaser()
            %NKTPLASER Construct an instance of this class
            %   Detailed explanation goes here
             
            % % Add the path of all the necessary header, dll and functions
            addpath(fullfile(pwd,'/headerAndFunctionsNKTPLaser/runtime/bin64/'));   
            addpath(fullfile(pwd,'/headerAndFunctionsNKTPLaser/runtime/include64/'));
            addpath(fullfile(pwd,'/headerAndFunctionsNKTPLaser/runtime/lib64/'));  
            
            %%% Load the library functions
            if not(libisloaded('NKTPDLL'))
                loadlibrary('NKTPDLL');
            end

            
            %% Setting the COM port for the LASER Module
            %%% Scan all the possible COM Ports 
            port_number = 20;  %% Assumptions: it will be maximum number of ports (COM ports) in the computer
            port_number_ptr = libpointer('uint16Ptr', port_number);
            out_number = 0;
            out_number_ptr = libpointer('uint16Ptr', out_number);
            cstring = repmat(' ', [1  1000]);  %% char type array of size (1, n)
            [portsPossible, out_number_ptr] = calllib('NKTPDLL', 'getAllPorts',cstring, port_number_ptr);
            clear cstring;
            %%% Split the content of portsPossible 
            portsActive = regexp(portsPossible, ',', 'split');
            portsActive = portsActive(1:end);
            
            %%% Check the COM port where the LASER module is connected
            for ii = 1:size(portsActive, 2)
                port_number = 20;  %% Assumption: it will be the maximum number of ports (COM port)
                port_number_ptr = libpointer('uint8Ptr', port_number);

                out_number = 0;
                out_number_ptr = libpointer('uint8Ptr', out_number);
                cstring = char(portsActive(ii)); 
                [result,  y, out_number_ptr] = calllib('NKTPDLL', 'deviceGetType',cstring,...
                    obj.addressModuleTypeLaserSource,  port_number_ptr);
                if (result == 0 && out_number_ptr == obj.moduleTypeLaserSource)
                    obj.portName = cstring;  
                    break;
                end
            end
            
            
            %% Set the LASER output with default parameters
            obj = setDefaultParameters(obj);
            disp('All the parameters are set to default');
                
        end
        
        
        
        
        %%
        %%% Function prototype to Turn ON the laser
        obj = turnONdevice(obj);
        
        %% Setter functions
        %%% Function prototype to set the power level of the LASER
        obj = setPowerLevel(obj, powerValue);
        
        %%% Function prototype to set the power level of the LASER at minimum value 
        obj = setPowerLevelMin(obj);
        
         %%% Function prototype to set the power level of the LASER at Maximum value 
        obj = setPowerLevelMax(obj);
        
        %%% Function prototype to set the wavelength of the LASER 
        obj = setWavelength(obj, lambda);
        
        %%% Function prototype to set all the parameters of the LASER to
        %%% the default value
        
        obj = setDefaultParameters(obj);
        
        
        %%% Function prototype to set the spectralBandWidth of the LASER
        %%% output
        obj = setBandWidth(obj, valueBandWidth);
        
        
        
        
        %% Getter functions
        obj = getPortName(obj);   %% function prototype to display the com PORT name where the laser is connected
        
        obj = getPowerLevel(obj); %% function prototype to display the powerlevel of the laser output beam
        
        obj = getWavelength(obj); %% function prototype to display the wavelength of the laser beam
        
        obj = getDefaultParameters(obj); %% function prototype to display all the default parameters of the laser souce
        
        obj = getRGBtriplet(obj, lambda);  %% The function will generate RGB triplet depending on the wavelength
        
        %% Turn OFF the LASER
        obj = turnOFFdevice(obj);
        
        
        %% Turn of the LASER
        %%% Function prototype to Trun OFF the laser and unload the library
        %%%  call this function if you do not want to Turn on the laser
        %%%  again 
       closeDevices(obj);
       
   
       
    end
end

