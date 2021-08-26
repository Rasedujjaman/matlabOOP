classdef SaveData < handle
    
    % This class will be used to save the data to specific location
    
    
    
    properties (Access = public)
        RootFolderPath
        FolderName  %% It will be today's date in the format (yyyymmdd)
        FolderPath  %% The directory where the data will be stored
        
        PreviousDate %%% For new date the counter values will be reset to zero, this variable stores the last
                     %%% date the experiment was conducted
        
        SnapShotCounter  
        ScanCounter
        
        
        ScanFileNameFirstPart = 'Scan';
        ScanFileNameSecondPart  % reserved variable
        SnapFileNameFirstPart = 'Snap';
        SnapFileNameSecondPart  % reserved variable
         
        
    end
    
    
    methods
        function obj = SaveData()
            
            %%% Read the RootFolderPath from the text file
            fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'RootFolderPath.txt'), 'r');
            obj.RootFolderPath = fscanf(fileID, '%s', Inf);
            fclose(fileID);
            
            %%% Read the PreviousDate from the text file
            fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'PreviousDate.txt'), 'r');
            obj.PreviousDate = fscanf(fileID, '%s', Inf);
            fclose(fileID);
            
            %%% Read the SnapShotCounter value from the text file
            fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'SnapShotCounter.txt'), 'r');
            obj.SnapShotCounter = fscanf(fileID, '%s', Inf);
            fclose(fileID);
            
            %%% Read the ScanCounter value from the text file
            fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'ScanCounter.txt'), 'r');
            obj.ScanCounter = fscanf(fileID, '%s', Inf);
            fclose(fileID);
            
            %%% Set the folder name
            obj.SetFolderName();
            %%% Set the folder path
            obj.SetFolderPath();
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Reset the counter if the PreviousDate ~= Today
            %%% (date format used: yyyymmdd)
            if(~strcmp(obj.FolderName, obj.PreviousDate))
                obj.ResetCounter('ScanCounter');
                obj.ResetCounter('SnapShotCounter');
                %%% Once this block of code is executed update the previous
                %%% dat text file
                fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'PreviousDate.txt'), 'w');
                obj.PreviousDate = obj.FolderName;
                fprintf(fileID,'%s', obj.PreviousDate);
                fclose(fileID);     
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
            
 
        
        
        
        
    %%% Function prototype to set the folder name
    obj = SetFolderName(obj);
     
    
    %%% Function prototype to set the folder path
    obj = SetFolderPath(obj);
    
    
    %%% Function prototype to set the file name     
    obj = SetFileName(obj, nameString);  %% Will be implemented later
    
    %%% Function prototype to update the counter value
    obj = IncrementCounter(obj, counterFileName);  %% This will increment the counter value by one
    
     
    %%% Function prototype to Reset the counter value 
    obj = ResetCounter(obj, counterFileName);   %% This will reset the counter to zero
        
        
        
    end
end

