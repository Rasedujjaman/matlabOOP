

function readOutTime = getReadoutTime(obj)

        [rc, readOutTime] = AT_GetFloat(obj.hndl,'ReadoutTime');
        AT_CheckWarning(rc);
        
        obj.ReadoutTime = readOutTime;


end
