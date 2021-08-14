  % % % Set the laser power at minimum value
        
        function  setPowerLevelMin(obj)
            
            [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeLaserSource,...
                 obj.regID_PowerLevel, 10*(obj.minPowerLevel), -1); %% set the power level of the LASER to minimum
            
            
       
            if (err1 == 0 )
                
                obj.powerLevel = obj.minPowerLevel;   %% update the current power level of the laser
                disp('Laser power is set at Minimum');
            end 

             
        end