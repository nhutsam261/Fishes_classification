clc;
clear;
addpath('D:\THIRD YEAR\Nh‚Ún daÚng m‚ﬁu\FishProject\SegmentFish');
%cnntest
pathdata1 ='D:\THIRD YEAR\Nh‚Ún daÚng m‚ﬁu\FishProject\FishDatabase';


Data = imageDatastore(pathdata1,...
    'IncludeSubfolders',true,'LabelSource','foldernames');
[trainingImages,testImages] = splitEachLabel(Data,0.7,'randomize');

for i=1:size(trainingImages.Files,1)
    path=trainingImages.Files{i};
    IM=imread(path);
    IM=imresize(IM,[32 32]);
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
    IM=imresize(IM,[32 32]);
    [rows columns numberOfColorChannels] = size(IM);
    if(numberOfColorChannels==1)
        disp(path)
    end
    imwrite(IM,path);
end
%%
img=readimage(Data,3);
Size=size(img);

[hog_2x2, vis2x2]=extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[16 16]);

% Show the original image
figure;
subplot(2,3,1:3); imshow(img);

% Visualize the HOG features
subplot(2,3,4);

plot(vis2x2);
title({'CellSize = [2 2]'; ['Length = ' num2str(length(hog_2x2))]});


subplot(2,3,5);
plot(vis4x4);
title({'CellSize = [4 4]'; ['Length = ' num2str(length(hog_4x4))]});

subplot(2,3,6);
plot(vis8x8);
title({'CellSize = [8 8]'; ['Length = ' num2str(length(hog_8x8))]});
%%
cellSize = [2 2];
hogFeatureSize = length(hog_2x2);
%%
numImages = numel(trainingImages.Files);
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1:numImages
    img = readimage(trainingImages, i);

    img = rgb2gray(img);

    % Apply pre-processing steps
    img = imbinarize(img);

    trainingFeatures(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
end
%%
trainingLabels = trainingImages.Labels;
classifier = fitcecoc(trainingFeatures, trainingLabels);

%%
[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testImages, hogFeatureSize, cellSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);
accuracy = sum(diag(confMat))/sum(confMat(:));
helperDisplayConfusionMatrix(confMat)

