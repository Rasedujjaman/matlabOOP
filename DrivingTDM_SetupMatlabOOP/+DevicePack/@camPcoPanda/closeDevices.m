  function closeDevices(obj)
        disp('Acquisition complete');
        
        if(obj.glvar.camera_open==1)
            obj.glvar.do_close=1;
            obj.glvar.do_libunload=1;
            pco_camera_open_close(obj.glvar);
        end
        
        
        imaqreset;  %% IT WILL RELEASE THE CAMEAR FROM MATLAB FORCEFULLY
        
        
        disp('Camera shutdown');
            
end