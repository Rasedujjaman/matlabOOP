
%% Close the Dac 

  function closeDevices(obj)
            delete (obj.ao_device);  
            clear  obj.ao_device          
            disp('Dac object is deleted and cleared');
            
 end