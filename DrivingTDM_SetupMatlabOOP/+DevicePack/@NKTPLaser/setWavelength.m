
%%% This function will set the wavelength of the laser

function obj = setWavelength(obj, lambda)
%%% Before setting the wavelength of the LASER 
%%% we will check if an integer number with permissible range is given or
%%% not

%%% If a non integer number is given then the number will be converted into
%%% an integer number with matlab built in floor() function
            
            minLambda = floor(lambda - obj.bandWidth/2);
            maxLambda = floor(lambda + obj.bandWidth/2);
% %             disp(obj.bandWidth)  %% display the current bandwidth
            if (minLambda >= obj.minWavelength && maxLambda <= obj.maxWavelength)
            
                [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_LWP, minLambda*10, -1); %% set the Long wave pass filter setpoint
                 
                 
                 [err2, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_SWP, maxLambda*10, -1); %% set the Short wave pass filter setpoint 
                 

            else
                    lambdaLowerLimit  = floor(obj.minWavelength + obj.bandWidth/2);
                    lambdaHigherLimit = floor(obj.maxWavelength - obj.bandWidth/2);
                    
                    disp(['With BandWidth of ', num2str(obj.bandWidth),'nm,', ' the centre Wavelength should be ',...
                        num2str(lambdaLowerLimit), 'nm to ', num2str(lambdaHigherLimit), 'nm']);
                    return; %% break the statement, we do not want to execute the below instructions 
            end
                
            
           
            if (err1 == 0 && err2 == 0)
                
                obj.waveLength = lambda;  %% update the current wavelength
                disp('Wavelength is set properly');
            end 
end
