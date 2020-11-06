function [fvectors, labels] = createFeatureVectors(bag, imgSet)
% initialize outputs
numImages = sum([imgSet.Count]);
fvectors  = zeros(numImages, bag.VocabularySize);
labels    = zeros(numImages, 1);
labels = arrayfun(@num2str, labels, 'UniformOutput', false);
NumCategories = numel(imgSet);

outIdx = 1;
            for cIdx=1:NumCategories                
                
                count = imgSet(cIdx).Count;

                % Encode each category
                fvectors(outIdx:outIdx+count-1,:) = encode(bag, imgSet(cIdx));
                indx = {imgSet(1, cIdx).Description};
                labels(outIdx:outIdx+count-1,1) = indx;
                outIdx = outIdx+count;
            end
end
