function ResizeImage(path, new_path, NumOfFish, Names)
for i=1:NumOfFish
    pathData=strcat(path,'\',Names{i+2});
    ImagesData=ReadImageDataFromFolder(pathData);
    mkdir(new_path,Names{i+2});
    for j=1:size(ImagesData,1)
        IM=imread(ImagesData{j,2});
        IM=imresize(IM,[200 300]);
        new_path1=strcat(new_path,'\',Names{i+2},'\',ImagesData{j,1},'.jpg');
        imwrite(IM,new_path1);
    end
end
