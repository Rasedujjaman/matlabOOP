




%% Capture 1 image               
function outImageFrame = getImageFrame(obj)

    if (obj.IsCaptureON == 0)
    StartCapture(obj);
    end

    trigger(obj.vid);
    outImageFrame = getdata(obj.vid);
    obj.Image = outImageFrame;


end