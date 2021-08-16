
%%% This function is buggy and need to be checked

function obj = setBandWidth(obj, valueBandWidth)

    valueBandWidth = floor(valueBandWidth);  %% If non integer value is provided convert it to integer
    
    if(valueBandWidth < obj.minBandWidth || valueBandWidth > obj.maxBandWidth)
        disp(['Bandwidth should be ', num2str(obj.minBandWidth), 'nm to ',...
            num2str(obj.maxBandWidth), 'nm']);
        return;
    else
        
            minLambda = floor(obj.waveLength - valueBandWidth/2);
            maxLambda = floor(obj.waveLength + valueBandWidth/2);
            
            if (minLambda >= obj.minWavelength)
                [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_LWP, minLambda*10, -1); %% set the Long wave pass filter setpoint
            else
                [err1, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_LWP, obj.minWavelength*10, -1); %% set the Long wave pass filter setpoint
            end
            
            if(maxLambda <= obj.maxWavelength)
                [err2, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_SWP, maxLambda*10, -1); %% set the Short wave pass filter setpoint 
            else
                [err2, y] = calllib('NKTPDLL', 'registerWriteU16',  obj.portName, obj.addressModuleTypeFilter,...
                     obj.regID_SWP, obj.maxWavelength*10, -1); %% set the Short wave pass filter setpoint 
            end
            
            if (err1 == 0 && err2 == 0)
                
                obj.bandWidth = valueBandWidth;  %% update the current bandwidth
                disp('BandWidth is set properly');
            end 
            
    end
    
                 
                
        