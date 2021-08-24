

function SetFolderPath(obj)

%%% Check if the FolderName is empty
    if (isempty(obj.FolderName))
        SetFolderName(obj); % set the FolderName properly
    end


%%% Check if the RootFolderPath is empty

    if(isempty(obj.RootFolderPath))
        disp('Something went wrong, Check the Root Folder path');
    else

        obj.FolderPath = fullfile(strcat(obj.RootFolderPath, obj.FolderName, '\'));
% %         if ~exist(obj.FolderPath)
% %             mkdir(obj.FolderPath)
% %         end
        disp('Folder path is set properly');
    end



end