% Authors: Bonell Marcela, Moya Ulises
% License: 
% Date: Jun 2015

clear all; close all;

% Read orignal video
original_video = VideoReader('videos/1-original.avi');

% Original video information
height_original = original_video.Height;
width_orginal = original_video.Width;

frame_rate_original = original_video.FrameRate;
number_frames_original = original_video.NumberOfFrames;

%fprintf('Frame rate in original: %d\n', frame_rate_original);
%fprintf('Number of frames in original: %d\n', number_frames_original);

start_index = 1;
end_index = number_frames_original;


width_roi = 150;
height_roi = 150;

% Show the first frame and the ROI
first_frame = read(original_video, start_index);
roi = imcrop(first_frame,[140 180 width_roi height_roi]);
imshow(first_frame), figure, imshow(roi)

original_intensity = zeros(10);
frames = 1:10;

% Calculate median and variace in the original video per frame
for i = start_index: 10
 
 frame = read(original_video, i);
 roi = imcrop(frame,[140 180 width_roi height_roi]);
 double_roi = im2double(roi);
 
 original_median = median(median(double_roi));
 original_variance = var(var(double_roi));
 
 fprintf('\nMedian in frame %d:\n',i);
 disp(original_median);
 
 fprintf('\nVariance in frame %d:\n',i);
 disp(original_variance);
 
 original_intensity(i) = median(original_median);
 
end 



% Draw the plot with the median of the original video
figure;
plot(frames,original_intensity);
title('Time vs Intensity (Original)');
xlabel('Frame');
ylabel('Intensity');




 