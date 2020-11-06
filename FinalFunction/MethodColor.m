clc;
clear;

addpath('...\FinalFunction'); % note : set path
pathData='...\Segment'; % note : set path
imds = imageDatastore(pathData,...
    'IncludeSubfolders',true,'LabelSource','foldernames');

[trainingImages,testImages] = splitEachLabel(imds,0.7,'randomize');

for i=1:size(trainingImages.Files,1)
    path=trainingImages.Files{i};
    vFeatures(i,:)=ColorFeatures(path);
end
%%
for i=1:size(testImages.Files,1)
    path=testImages.Files{i};
    vFeaturesTest(i,:)=ColorFeatures(path);
end
%%
train_data=vFeatures;
train_label=trainingImages.Labels;
train_label=cellstr(train_label);
t = templateKNN('NumNeighbors',2,'Standardize',1);
KNNMdl = fitcecoc(train_data, train_label,'Learners',t,'Verbose',2);


%%
test_data=vFeaturesTest;
test_label=testImages.Labels;
test_label=cellstr(test_label);
%%
[acc2, err2] = evaluate(KNNMdl,test_data, test_label);
acc2
err2
%%
t = templateNaiveBayes('DistributionNames','kernel');
BayesMdl = fitcecoc(train_data, train_label,'Learners',t, 'Verbose', 2);
[acc1, err1] = evaluate(BayesMdl, test_data, test_label);
acc1
err1
%%

new_label = zeros(5, size(train_data,1));
for i = 1:length(imds.Labels)
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
test_label = [new_label(:,29:40), new_label(:,69:80), new_label(:,109:120), new_label(:,149:160), new_label(:,189:200)]; 
%%
setdemorandstream(391418381)
net = patternnet(10);

test_data=test_data';
test_label=test_label';
train_data=train_data';
train_label=train_label';

%%
maxANN=0;
for i=1:100
[net, tr] = train(net,train_data,train_label);
nntraintool

testY = net(test_data);
testIndices = vec2ind(testY);
plotconfusion(test_label, testY);
[error,confmat] = confusion(test_label, testY)
maxANN=max(maxANN,1-error);
end
%%

train_data=vFeatures;
train_label=trainingImages.Labels;
train_label=cellstr(train_label);

test_data=vFeaturesTest;
test_label=testImages.Labels;
test_label=cellstr(test_label);

opts = templateSVM('KernelFunction','polynomial');
categoryClassifier = fitcecoc(train_data,train_label,'Learners',opts,'Verbose',2);

confMatrix = evaluate(categoryClassifier,test_data, test_label)
mean(diag(confMatrix))
% Find the average accuracy of the classification.
svm=mean(diag(confMatrix));
%%

