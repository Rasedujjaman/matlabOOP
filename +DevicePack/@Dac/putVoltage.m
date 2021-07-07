%% This function of the Dac object do the actual job to suppy voltage the 
%% each channels


function putVoltage(obj, voltX, voltY)
            if nargin == 1
                outputSingleScan(obj.ao_device,[obj.voltChannelX  obj.voltChannelY]);
            elseif nargin == 2
                outputSingleScan(obj.ao_device,[voltX  obj.voltChannelY]);
            else
                outputSingleScan(obj.ao_device,[voltX  voltY]);
            end
  end
            