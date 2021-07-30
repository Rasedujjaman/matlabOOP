

%% when invoked this function, both the channel voltage is set to zero

function obj = goHome(obj)
    
        outputSingleScan(obj.ao_device,[0  0]);

end
       