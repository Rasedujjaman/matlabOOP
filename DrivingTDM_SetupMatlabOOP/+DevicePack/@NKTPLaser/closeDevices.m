  % % % This function will turn off the laser and unload the libraries
        
        function  closeDevices(obj)
            %%% To turn off the laser
            %%% Before turning OFF the laser, all the parameters are set to
            %%% default values
            
            %% Set the power level, wavelength and sepectral bandwidth to default values                        
             setDefaultParameters(obj);
    
            %% To turn OFF the LASER 
            [err, y] = calllib('NKTPDLL', 'registerWriteU8', obj.portName, obj.addressModuleTypeLaserSource,...
                        obj.regID_ONandOFF, obj.valueTurnOFF_Laser, -1);  

            %%
            if (err == 0)
                unloadlibrary('NKTPDLL'); %% unload the NKTPDLL library
                disp('All the parameters are set to default');
                disp('Laser is closed');
            end 

             
        end