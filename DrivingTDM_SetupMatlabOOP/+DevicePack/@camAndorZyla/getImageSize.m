   function outPutImageSize = getImageSize(obj)
            [rc, outPutImageSize] = AT_GetInt(obj.hndl,'ImageSizeBytes');
             AT_CheckWarning(rc);
   end