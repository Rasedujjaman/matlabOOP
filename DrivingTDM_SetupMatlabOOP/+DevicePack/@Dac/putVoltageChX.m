%% This function of the Dac object do the actual job to suppy voltage
%% to the channelX


function putVoltageChX(obj, voltX)

    outputSingleScan(obj.ao_device,[voltX  obj.voltChannelY]);
    %%% update the channelX voltage
    obj.voltChannelX = voltX;

end

            