function  CropFeeder(dataFolder,targetFolder,roi)
% The default video episodes used the extended feeder area as ROI
% However, custom ROI can be defined and cropped based on raw videos
% Here we provide two ROIs: feeder only and truncated feeder
% Note: in our study, the truncated feeder yielded the best performance

if ~exist(targetFolder, 'dir')
    mkdir(targetFolder)
end
listing = dir(fullfile(dataFolder,'*.mp4'));
warning('off');
for i=1:length(listing) 
    name = listing(i).name;
    folder = listing(i).folder;
    tmp_video = VideoReader(fullfile(folder,name));

    if contains(name,'Feeder1')
        region = reshape(roi(1,:),1,4);
    else
        region = reshape(roi(2,:),1,4);
    end
    
    new_video = strcat(targetFolder,name);
    RGBObj = VideoWriter(new_video,'MPEG-4');
    open(RGBObj);
    for j=1:30
        tmp_frame = read(tmp_video,j);
        tmp_frame = imcrop(tmp_frame,region);
        writeVideo(RGBObj,tmp_frame);
    end
    
    close(RGBObj);
end
warning('on');