%%
clear all
clc
imgFolder = fullfile('..\FishDataset_Resized');
imgSets = imageSet(imgFolder,'recursive');

%%
[trainingSets, testSets] = partition(imgSets, 0.7, 'sequential');

%%
bag = bagOfFeatures(trainingSets,'PointSelection','Detector','VocabularySize',128);
%%
[fvectors, labels] = createFeatureVectors(bag,imgSets);
%%
train_data = [fvectors(1:28,:); fvectors(41:68,:); fvectors(81:108,:); fvectors(121:148,:); fvectors(161:188,:)];
train_data = train_data';
new_label = zeros(5, size(fvectors,1));
for i = 1:length(labels)
    if (0 < i) && (i < 41)
        new_label(1,i) = 1;
    elseif (40 < i) && (i < 81)
        new_label(2,i) = 1;
    elseif (80 < i) && (i < 121)
        new_label(3,i) = 1;
    elseif (120 < i) && (i < 161)
        new_label(4,i) = 1;
    elseif (160 < i) && (i < 201)
        new_label(5,i) = 1;
    end
end
train_label = [new_label(:,1:28), new_label(:,41:68), new_label(:,81:108), new_label(:,121:148), new_label(:,161:188)];
test_data = [fvectors(29:40,:); fvectors(69:80,:); fvectors(109:120,:); fvectors(149:160,:); fvectors(189:200,:)];
test_data = test_data';
test_label = [new_label(:,29:40), new_label(:,69:80), new_label(:,109:120), new_label(:,149:160), new_label(:,189:200)];
%%
setdemorandstream(391418381)
net = patternnet(10);
view(net);
%%
[net, tr] = train(net,train_data,train_label);
nntraintool
%%
testY = net(test_data);
testIndices = vec2ind(testY);
plotconfusion(test_label, testY);
[error,confmat] = confusion(test_label, testY)
