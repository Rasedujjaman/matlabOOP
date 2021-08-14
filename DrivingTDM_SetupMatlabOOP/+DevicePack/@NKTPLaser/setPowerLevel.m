
%%% This function will set the power level of the laser

function obj = setPowerLevel(obj, powerValue)
%%% Before setting the power level of the LASER 
%%% we will check if an integer number with permissible range is given or
%%% not

%%% If a non integer number is given then the number will be converted into
%%% an integer number with matlab built in floor() function
            
            
            if (floor(powerValue) >= obj.minPowerLevel && floor(powerValue) <= obj.maxPowerLevel)
            
                [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeLaserSource,...
                     obj.regID_PowerLevel, 10*powerValue, -1); %% set the power level of the LASER
                 
                 %%%% The powerValue is multiplied by a factor 10, this is
                 %%%% because the register accept the value from 
                 %%% (0 to 1000) but whereas we supply the value from (0 to
                 %%% 100). So 100 corresponds to 1000. 
              

            else
                    disp('Power level should be 0 to 100');
                    return; %% break the statement, we do not want to execute the below instructions 
            end
                
            
           
            if (err1 == 0 )
                obj.powerLevel = powerValue;   %% update the current power level of the laser
                disp('Power level is set properly');
            end 
end
