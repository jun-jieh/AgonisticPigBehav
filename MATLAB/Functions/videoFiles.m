function [files, labels] = videoFiles(dataFolder,fraction)
%videoFiles List of files and labels from our pig dataset
%   [files, labels] = videoFiles(dataFolder,percentage) returns a list of files and
%   labels from the dataset given by dataFolder
%   the fraction input must be in the range [0 1] this allows you to 
%   only return a random subset of files and lables 
%   If only one input argument is given, the fraction is equal to 1 by
%   default and the dataset is not permutated.

if nargin == 1
    fraction = 1;
end

fileExtension = ".mp4";
listing = dir(fullfile(dataFolder, "*", "*" + fileExtension));
numObservations = numel(listing);
numSubsetObservations = floor(numObservations*fraction);

if nargin == 2
    idx = randperm(numObservations,numSubsetObservations);
    listing = listing(idx);
end

files = strings(numSubsetObservations,1);
labels = cell(numSubsetObservations,1);

for i = 1:numSubsetObservations
    name = listing(i).name;
    folder = listing(i).folder;
    
    [~,labels{i}] = fileparts(folder);
    files(i) = fullfile(folder,name);
end

labels = categorical(labels);

end
