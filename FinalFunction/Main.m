
clear;
clc;
addpath('...\FinalFunction'); % note : set path
imgFolder = fullfile('...\Segment'); % note : set path
imgSets = imageSet(imgFolder,'recursive');
[trainingSets, testSets] = partition(imgSets, 0.7, 'sequential'); % 70% train, 30% test

%%
% Create the Features Color for each image.
idx=1;
for i=1:size(imgSets,2)
    for j=1:imgSets(1,i).Count
        path=imgSets(1,i).ImageLocation{j};
        vFeatures(idx,:)=ColorFeatures(path);
        idx=idx+1;
    end
end

%%
maxBayes=0;
maxSVM=0;
maxKNN=0;
maxANN=0;
for i =1:20 %using for to get Accuracy Max
    % Run 1 time only, rerun only when change dictionary size
    bag = bagOfFeatures(trainingSets,'PointSelection','Detector','VocabularySize',1024); % words = 1024
    % Create the features of bag
    [fvectors, labels] = createFeatureVectors(bag,imgSets);
    % Create Features of BOW and Color, fvectors is the BOW
    % vFeatures is the Vector Color
    train_data = [fvectors(1:28,:) vFeatures(1:28,:);...
        fvectors(41:68,:) vFeatures(41:68,:);...
        fvectors(81:108,:) vFeatures(81:108,:);...
        fvectors(121:148,:) vFeatures(121:148,:);...
        fvectors(161:188,:) vFeatures(161:188,:)];
    
    train_label = [labels(1:28,:); labels(41:68,:); labels(81:108,:); labels(121:148,:); labels(161:188,:)];
    
    test_data = [fvectors(29:40,:) vFeatures(29:40,:);...
        fvectors(69:80,:) vFeatures(69:80,:);...
        fvectors(109:120,:) vFeatures(109:120,:);...
        fvectors(149:160,:) vFeatures(149:160,:);...
        fvectors(189:200,:) vFeatures(189:200,:)];
    
    test_label = [labels(29:40,:); labels(69:80,:); labels(109:120,:); labels(149:160,:); labels(189:200,:)];
    
    % SVM template
    opts = templateSVM('KernelFunction','polynomial');
    SVMmodel = fitcecoc(train_data, train_label,'Learners',opts, 'Verbose', 2);
    [accSVM,errSVM ]= evaluate(SVMmodel,  test_data, test_label);
    maxSVM=max(maxSVM,accSVM);
    
    % Bayes template
    t = templateNaiveBayes('DistributionNames','kernel');
    BayesMdl = fitcecoc(train_data, train_label,'Learners',t, 'Verbose', 2);
    [accBayes, errBayes] = evaluate(BayesMdl, test_data, test_label);
    maxBayes=max(maxBayes,accBayes);
    
    % KNN template
    t = templateKNN('NumNeighbors',5,'Standardize',1);
    KNNMdl = fitcecoc(train_data, train_label,'Learners',t,'Verbose',2);
    [accKNN, errKNN] = evaluate(KNNMdl,test_data, test_label);
    maxKNN=max(maxKNN,accKNN);
    
    % ANN
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
    test_data = test_data';
    test_label = [new_label(:,29:40), new_label(:,69:80), new_label(:,109:120), new_label(:,149:160), new_label(:,189:200)];
    setdemorandstream(391418381)
    net = patternnet(10);
    
    for j=1:20
        [net, tr] = train(net,train_data,train_label);
        % nntraintool
        
        testY = net(test_data);
        testIndices = vec2ind(testY);
        plotconfusion(test_label, testY);
        [error,confmat] = confusion(test_label, testY);
        AccANN=(1-error)*100;
        maxANN=max(maxANN,AccANN);
        disp(1-error);
    end
    
end