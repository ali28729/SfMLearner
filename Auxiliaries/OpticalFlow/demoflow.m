%Creating File
fileID = fopen('..\..\drone_videos\Dataset\2011_09_28\static_frames.txt','w');
fmt = '%s %s %s\n';
fclose(fileID);

%high level directories
srcDir = '..\..\drone_videos\Dataset\2011_09_28';
subDir = 'image_02\data';

%Getting Subfolders
files = dir('..\..\drone_videos\Dataset\2011_09_28')
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..')
% Extract only those that are directories.
subFolders = files(dirFlags)


%Looping subfolders
for k = 1 : length(subFolders)
    vid = subFolders(k).name;
    srcStruc = dir(fullfile(srcDir,vid,subDir,'*.png'));
    srcFiles = natsortfiles({srcStruc.name});
    
    %Looping Images
    for j = 2:numel(srcFiles)
        file1 = fullfile(srcDir,vid,subDir,srcStruc(j-1).name);
        file2 = fullfile(srcDir,vid,subDir,srcStruc(j-0).name);
        flag = FlowCheck(file1, file2);
        if (flag == true)
            fileID = fopen('..\..\drone_videos\Dataset\2011_09_28\static_frames.txt','a');
            imName = strsplit(srcStruc(j-1).name, '.');
            fprintf(fileID,fmt, '2011_09_28', vid, imName{1} );
            fclose(fileID);
        end
    end 
end