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
bagOfTraining = bagOfFeatures(trainingImages,'PointSelection','Detector');
bagOfTesting = bagOfFeatures(testImages,'PointSelection','Detector');
%%

for i=1:size(trainingImages.Files,1)
    path=trainingImages.Files{i};
    img=imread(path);
    vtFeatureTraining(i,:)=encode(bagOfTraining,img);
end

for i=1:size(testImages.Files,1)
    path=testImages.Files{i};
    img=imread(path);
    vtFeatureTesting(i,:)=encode(bagOfTesting,img);
end


%%

    for i=1:size(vtFeatureTraining,1)
        for j=1:size(vtFeatureTraining,2)
            if vtFeatureTraining(i,j)==0
                vtFeatureTraining(i,j)=0.0000001;
          
            end
        end
    end
  
     for i=1:size(vtFeatureTesting,1)
        for j=1:size(vtFeatureTesting,2)
            if vtFeatureTesting(i,j)==0
                vtFeatureTesting(i,j)=0.0000001;
          
            end
        end
    end
%%
training.features=vtFeatureTraining;
training.labels=trainingImages.Labels;

testing.features=vtFeatureTesting;
testing.labels=testImages.Labels;
%%
BayesModel=fitcnb(training.features, training.labels);
%%
testing.predict_labels=BayesModel.predict(testing.features);
predictMat=confusionmat(testing.labels,testing.predict_labels);
disp(sum(diag(predictMat))/sum(predictMat(:)));