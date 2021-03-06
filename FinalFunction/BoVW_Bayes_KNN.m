%%
clear all
clc
imgFolder = fullfile('..\FishDataset_Resized');
imgSets = imageSet(imgFolder,'recursive');

%%
[trainingSets, testSets] = partition(imgSets, 0.7, 'sequential');

%%
bag = bagOfFeatures(trainingSets,'PointSelection','Detector','VocabularySize',50);
%%
[fvectors, labels] = createFeatureVectors(bag,imgSets);
%%
train_data = [fvectors(1:28,:); fvectors(41:68,:); fvectors(81:108,:); fvectors(121:148,:); fvectors(161:188,:)];
train_label = [labels(1:28,:); labels(41:68,:); labels(81:108,:); labels(121:148,:); labels(161:188,:)];
test_data = [fvectors(29:40,:); fvectors(69:80,:); fvectors(109:120,:); fvectors(149:160,:); fvectors(189:200,:)];
test_label = [labels(29:40,:); labels(69:80,:); labels(109:120,:); labels(149:160,:); labels(189:200,:)];
%%
t = templateNaiveBayes('DistributionNames','kernel');
BayesMdl = fitcecoc(train_data, train_label,'Learners',t, 'Verbose', 2);
%%
t = templateKNN('NumNeighbors',1,'Standardize',1);
KNNMdl = fitcecoc(train_data, train_label,'Learners',t,'Verbose',2);
%% 
[acc1, err1] = evaluate(BayesMdl, test_data, test_label);
acc1
err1
%%
[acc2, err2] = evaluate(KNNMdl,test_data, test_label);
acc2
err2