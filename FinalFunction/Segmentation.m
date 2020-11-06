%%
clc;
clear all;
close all;
addpath('D:\Matlab Scripts\PatternRecognition\FishClassification\FishProject\SegmentFish');
path ='D:\Matlab Scripts\PatternRecognition\FishClassification\FishProject\FishProject\FishDataset';
pathSegment=('D:\Matlab Scripts\PatternRecognition\FishClassification\FishProject\FishProject\Segment');
new_path='D:\Matlab Scripts\PatternRecognition\FishClassification\FishProject\FishProject\FishDataset_Resized';
DataFolder=dir(path);
Names={DataFolder.name};
Data=cell(size(Names,2)-2,3);
NumOfFish=size(Data,1);
%%
ResizeImage(path, new_path, NumOfFish, Names)
%%
% for i=1:NumOfFish
%     pathData=strcat(path,'\',Names{i+2});
%     ImagesData=ReadImageDataFromFolder(pathData);
%     mkdir(pathSegment,Names{i+2});
%     pathSegment=strcat(pathSegment,'\',Names{i+2});
% %     SegmentImage(ImagesData,pathSegment);
%     
% end
%%
% pathData=strcat(path,'\',Names{3});
% ImageData=ReadImageDataFromFolder(pathData);
% mkdir(pathSegment,Names{3});
% pathSegment=strcat(pathSegment,'\',Names{3});
% SegmentImage(ImageData,pathSegment);
%%
ImageData=ReadImageDataFromFolder(strcat(new_path,'\',Names{4}));
mkdir(pathSegment,Names{5});
%%
for i = 2:size(ImageData,1)
IM_path=ImageData{i,2};
IM=imread(IM_path);
Res=SegmentBySuperPixelAndRGB(IM,0.48);
% Res=SegmentByMask(IM,BW3);
% imshows(1,2, {IM Res});
% GrayIM=rgb2gray(IM);
% BW=imbinarize(GrayIM);
% BW=1-BW;
% BW=imfill(BW,'holes');
% Res=SegmentByMask(IM,BW);
% imshows(1,3,{IM BW Res});

% White background segment
% mask=zeros(size(GrayIM));
% mask(15:end-15,15:end-15)=1;
% BW=activecontour(GrayIM,mask,700,'edge');
% Res=SegmentByMask(IM,BW);
% imshows(1,3, {IM BW Res});

% new_path1=strcat(pathSegment,'\',Names{7},'\',ImageData{i,1},'.jpg');
% imwrite(Res,new_path1);
end
%%
new_path1=strcat(pathSegment,'\',Names{4},'\','3.jpg');
%%
imwrite(Res,new_path1);