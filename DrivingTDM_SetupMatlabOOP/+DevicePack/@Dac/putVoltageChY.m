%% This function of the Dac object do the actual job to suppy voltage
%% to the channelX


function putVoltageChY(obj, voltY)

    outputSingleScan(obj.ao_device,[obj.voltChannelY voltY]);
    %%% update the channelY voltage
    obj.voltChannelY = voltY;

end

            