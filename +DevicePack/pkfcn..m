

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