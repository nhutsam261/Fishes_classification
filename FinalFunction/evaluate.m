function [Accuracy, Error] = evaluate(Mdl, test_data, test_label)
islabel = predict(Mdl, test_data);
ConfusionMat = confusionmat(test_label, islabel)
sum = 0;
for i = 1:length(test_label)
    if strcmp(test_label{i,1},islabel{i,1})
        sum = sum+1;
    end
end
Accuracy = sum/length(test_label)*100;
Error = 100-Accuracy;