function [ ImageData ] = ReadImageDataFromFolder( FolderPath)
%READIMAGEDATAFROMFOLDER Summary of this function goes here
%   Detailed explanation goes here
    DirInfo = dir(FolderPath);
    ImageNames = {DirInfo.name};
    
    ImageData = cell(size(ImageNames,2)-2, 3);
    NumberOfImages = size(ImageData,1);

    for i = 1 : NumberOfImages
       disp(['Reading image : ' num2str(i) '/' num2str(NumberOfImages)]);
       [~,ImageData{i,1},~] = fileparts(ImageNames{i+2});
       ImageData{i,2} = [FolderPath '\' ImageData{i,1} '.jpg'];
       ImageData{i,3} = imread(ImageData{i,2});
    end
end

