classdef SaveData < handle
    
    % This class will be used to save the data to specific location
    
    
    
    properties (Access = public)
        RootFolderPath
        FolderName
        FolderPath
        FileNameFirstPart
        FileNameSecondPart
    end
    
    
    methods
        function obj = SaveData()
            
            addpath(fullfile(pwd,'/headerAndFunctionsSaveData/'));   
            fileID = fopen('RootFolderPath.txt','r');
            obj.RootFolderPath = fscanf(fileID, '%s', Inf);
            fclose(fileID);
        end
        
        
        
        
    %%% Function prototype to set the folder name
    obj = SetFolderName(obj);
     
    
    %%% Function prototype to set the folder path
    obj = SetFolderPath(obj);
    
    
    %%% Function prototype to set the file name (first part)
    
    obj = SetFileNameFirstPart(obj, nameString);
    
    %%% Function prototype to set the file name (second part)
    obj = SetFileNameSecondPart(obj);
    
    
    %%% Function prototype to set the root folder path
    obj = SetRootFolderPath(obj);
    
        
        
        
        
    end
end

