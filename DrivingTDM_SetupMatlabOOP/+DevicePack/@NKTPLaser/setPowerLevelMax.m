  % % % Set the laser power at maximum value
        
        function  setPowerLevelMax(obj)
            
            [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeLaserSource,...
                 obj.regID_PowerLevel, 10*(obj.maxPowerLevel), -1); %% set the power level of the LASER to maximum
            
            
       
            if (err1 == 0 )
                
                obj.powerLevel = obj.maxPowerLevel;   %% update the current power level of the laser
                disp('Laser power is set at Maximum');
            end 

             
        end