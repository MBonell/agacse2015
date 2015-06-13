% Authors: E. Ulises Moya-Sánchez, Bonell Manjarrez Marcela
% License: 
% Date: Jun 2015

clear all; close all;

% Read orignal video
original_video = VideoReader('videos/1-original.avi');

% Read magnified video
magnified_video = VideoReader('videos/1-magnified.avi');

% Original video information
height_original = original_video.Height;
width_orginal = original_video.Width;

frame_rate_original = original_video.FrameRate;
number_frames_original = original_video.NumberOfFrames;

%fprintf('Frame rate in original: %d\n', frame_rate_original);
%fprintf('Number of frames in original: %d\n', number_frames_original);

start_index = 1;
end_index   = number_frames_original;

width_roi   = 80;
height_roi  = 80;

% Show the first frame and the ROI
first_frame = read(original_video, start_index);
original_roi = imcrop(first_frame,[140 180 width_roi height_roi]);
imshow(first_frame), figure, imshow(original_roi)

n = 48;
frames = 1:n;

original_intensity  = zeros(1,n);
original_error      = zeros(1,n);
magnified_intensity = zeros(1,n);
magnified_error     = zeros(1,n);

% Calculate mean and variace in the videos per frame
for i = start_index: n
 
 original_frame = read(original_video, i);
 original_roi   = rgb2gray(imcrop(original_frame,[140 180 width_roi height_roi]));
 original_double_roi = im2double(original_roi);
 
 magnified_frame = read(magnified_video, i);
 magnified_roi = rgb2gray(imcrop(magnified_frame,[140 180 width_roi height_roi]));
 magnified_double_roi = im2double(magnified_roi);
 
 
 original_mean      = mean(original_double_roi(:));
 original_variance  = var(original_double_roi(:));
 
 magnified_mean     = mean(magnified_double_roi(:));
 magnified_variance = var(magnified_double_roi(:));
 
 
 fprintf('\nOriginal/Magnified mean in frame %d:\n',i);
 disp(original_mean);
 disp(magnified_mean);
 
 fprintf('\nOriginal/Magnified variance in frame %d:\n',i);
 disp(original_variance);
 disp(magnified_variance);
 
 
 original_intensity(i) = original_mean;
 original_error(i) = original_variance;
 
 magnified_intensity(i) = magnified_mean;
 magnified_error(i) = magnified_variance;
 
end 



% Draw the plot error with the mean of the original video
figure;
errorbar(1:n, original_intensity, original_error, '*');
% ylim([0 .5])
title('Time vs Intensity (Original)');
xlabel('Frame');
ylabel('Intensity');


% Draw the plot error with the mean of the magnified video
figure;
errorbar(1:n, magnified_intensity, magnified_error, '*');
% ylim([0 .5])
title('Time vs Intensity (Magnified)');
xlabel('Frame');
ylabel('Intensity');





 