
function obj = getTrigerMode(obj)
 [errorCode,~,triggermode] = calllib('PCO_CAM_SDK', 'PCO_GetTriggerMode', obj.out_ptr,obj.triggermode);
 
 disp(triggermode);
end