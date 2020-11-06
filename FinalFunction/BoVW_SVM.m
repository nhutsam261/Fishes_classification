%%
clear all
clc
imgFolder = fullfile('..\data\Segment_Resized');
imgSets = imageSet(imgFolder,'recursive');
%%
[trainingSets, testSets] = partition(imgSets, 0.7, 'sequential');

%% Run 1 time only, rerun only when change dictionary size
bag = bagOfFeatures(trainingSets,'PointSelection','Detector','VocabularySize',64);
%% SVM template
opts = templateSVM('KernelFunction','polynomial');
categoryClassifier = trainImageCategoryClassifier(trainingSets, bag,'LearnerOptions',opts);

confMatrix = evaluate(categoryClassifier, trainingSets)
mean(diag(confMatrix))
confMatrix = evaluate(categoryClassifier, testSets)
% Find the average accuracy of the classification.
mean(diag(confMatrix))
