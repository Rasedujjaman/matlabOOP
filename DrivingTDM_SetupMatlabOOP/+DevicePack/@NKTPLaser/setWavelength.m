
%%% This function will set the wavelength of the laser

function obj = setWavelength(obj, lambda)
%%% Before setting the wavelength of the LASER 
%%% we will check if an integer number with permissible range is given or
%%% not

%%% If a non integer number is given then the number will be converted into
%%% an integer number with matlab built in floor() function
            
            minLambda = floor(lambda - obj.bandWidth/2);
            maxLambda = floor(lambda + obj.bandWidth/2);
            disp(obj.bandWidth)
            if (minLambda >= obj.minWavelength && maxLambda <= obj.maxWavelength)
            
                [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_SWP, floor(minLambda/10), -1); %% set the Short wave pass filter setpoint 
                 
                 
                 [err2, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_LWP, floor(maxLambda/10), -1); %% set the Long wave pass filter setpoint
                 
                 [err3, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     50, 1, -1); %% set the Long wave pass filter setpoint
                 

            else
                    disp('Wavelength should be 400 to 840');
                    return; %% break the statement, we do not want to execute the below instructions 
            end
                
            
           
            if (err1 == 0 && err2 == 0 && err3 == 0 )
                disp('Wavelenght is set properly');
            end 
end
