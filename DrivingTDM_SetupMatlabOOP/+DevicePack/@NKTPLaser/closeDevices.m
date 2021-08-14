  % % % Close the devices
        
        function  closeDevices(obj)
            %%% To turn off the laser
            %%% Before turning OFF the laser, set the power level to 0
            [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeLaserSource,...
                 obj.regID_PowerLevel, obj.minPowerLevel, -1); %% set the power level of the LASER to zero
            
            
            
            [err2, y] = calllib('NKTPDLL', 'registerWriteU8', obj.portName, obj.addressModuleTypeLaserSource,...
                        obj.regID_ONandOFF, obj.valueTurnOFF_Laser, -1);  %% To turn OFF the LASER

            if (err1 == 0 && err2  == 0)
                unloadlibrary('NKTPDLL'); %% unload the NKTPDLL library
                disp('Laser is closed');
            end 

             
        end