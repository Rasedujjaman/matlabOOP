  function closeDevices(obj)
        disp('Acquisition complete');
        [rc] = AT_Command(obj.hndl,'AcquisitionStop');
        AT_CheckWarning(rc);
        [rc] = AT_Flush(obj.hndl);
        AT_CheckWarning(rc);
        [rc] = AT_Close(obj.hndl);
        AT_CheckWarning(rc);
        [rc] = AT_FinaliseLibrary();
        AT_CheckWarning(rc);
        disp('Camera shutdown');
            
end