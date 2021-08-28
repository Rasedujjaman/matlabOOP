

% Definition package function
function z = pkfcn(x,y)
% Definition Package Class
classdef StandaMotor

% % % % % Method 1: Complete Name Call
% % % % % Call package function
% z = mypack.pkfcn(x,y);
% % % % % Creation class object
% obj=mypack.myclass(arg)
% % % % % Call class object method
% obj.myMethod(arg)
% % % % % Of the static method of the class
% mypack.myClass.stMethod(arg)
% 




% Method 2: Import, directly pass method or class name
import DevicePack.*
import DevicePack.StandaMotor.*
% Call package function
z = pkfcn(x,y);
% Creation class object
obj = StandaMotor(arg);
% Call class object method
obj.myMethod(arg);
% Of the static method of the class
StandaMotor.stMethod(arg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The Dac class
classdef Dac
import DevicePack.*
import DevicePack.Dac.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=Dac(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
Dac.stMethod(arg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% New modification on July 29, 2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The CameraAndorZyla class 
classdef CameraAndorZyla
import DevicePack.*
import DevicePack.CameraAndorZyla.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=CameraAndorZyla(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
CameraAndorZyla.stMethod(arg);



%%%% The CameraPhotonFocus class 
classdef CameraPhotonFocus
import DevicePack.*
import DevicePack.CameraPhotonFocus.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=CameraPhotonFocus(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
CameraPhotonFocus.stMethod(arg);




%%%% The CameraPcoPanda class 
classdef CameraPcoPanda
import DevicePack.*
import DevicePack.CameraPcoPanda.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=CameraPcoPanda(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
CameraPcoPanda.stMethod(arg);

%%%% The LASER source
classdef NKTPLaser
import DevicePack.*
import DevicePack.NKTPLaser.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=NKTPLaser(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
NKTPLaser.stMethod(arg);



%%%% The scanPattern class
classdef ScanPattern
import DevicePack.*
import DevicePack.ScanPattern.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=ScanPattern(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
ScanPattern.stMethod(arg);




%%%% SaveData class
classdef SaveData
import DevicePack.*
import DevicePack.SaveData.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=SaveData(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
SaveData.stMethod(arg);




%%%% The camPcoPanda class 
classdef camPcoPanda
import DevicePack.*
import DevicePack.camPcoPanda.*

% Call package function
z = pkfcn(x,y);

% Creation class object
obj=camPcoPanda(arg);

% Call class object method
obj.myMethod(arg);
% Of the static method of the class
camPcoPanda.stMethod(arg);