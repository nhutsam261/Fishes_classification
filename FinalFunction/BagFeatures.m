
clc;
clear;
pathData='D:\THIRD YEAR\Nh‚Ún daÚng m‚ﬁu\FishProject\FishDataset';
categories={'AulonocaraFire','Discus','FlameFish','KingFish','MollyFish'};
imds = imageDatastore(pathData,...
    'IncludeSubfolders',true,'LabelSource','foldernames');

[trainingImages,testImages] = splitEachLabel(imds,0.7,'randomize');

for i=1:size(trainingImages.Files,1)
    path=trainingImages.Files{i};
    IM=imread(path);
    IM=imresize(IM,[200 300]);
    [rows columns numberOfColorChannels] = size(IM);
    if(numberOfColorChannels==1)
        disp(path)
    end
    imwrite(IM,path);
end
%%
for i=1:size(testImages.Files,1)
    path=testImages.Files{i};
    IM=imread(path);
    IM=imresize(IM,[200 300]);
    [rows columns numberOfColorChannels] = size(IM);
    if(numberOfColorChannels==1)
        disp(path)
    end
    imwrite(IM,path);
end

%%
bag = bagOfFeatures(trainingImages);
%%
img = readimage(imds, 1);
featureVector = encode(bag, img);

% Plot the histogram of visual word occurrences
figure
bar(featureVector)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')
%%
categoryClassifier = trainImageCategoryClassifier(trainingImages, bag);
%%
[confMat, knownLabelIdx, predictedLabelIdx, score] = evaluate(categoryClassifier, testImages);
%%
accuracy=mean(diag(confMat));