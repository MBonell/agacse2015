% Authors: E. Ulises Moya-Sánchez, Bonell Manjarrez Marcela
% Date: Jun 2015

clear all; close all;

% Read videos
leap_motion_video = VideoReader('leap-motion.mp4');
infrared_video = VideoReader('infrared.avi');
depth_video = VideoReader('depth.avi');

% Videos information
fprintf('Frame rate (Leap Motion): %.2f\n', leap_motion_video.FrameRate);
fprintf('Frame rate (Infrared): %.2f\n', infrared_video.FrameRate);
fprintf('Frame rate (Depth): %.2f\n\n', depth_video.FrameRate);

width_roi   = 80;
height_roi  = 80;

% Show the first frames and the ROI
leap_motion_frame = read(leap_motion_video, 194);
figure('Name', 'Leap Motion'), imshow(leap_motion_frame);
leap_motion_roi = imcrop(leap_motion_frame,[600 650 width_roi height_roi]);
figure('Name', 'ROI - Leap Motion'), imshow(leap_motion_roi);

infrared_frame = read(infrared_video, 95);
figure('Name', 'Infrared'), imshow(infrared_frame);
infrared_roi = imcrop(infrared_frame,[290 240 width_roi height_roi]);
figure('Name', 'ROI - Infrared'), imshow(infrared_roi);

depth_frame = read(depth_video, 426);
figure('Name', 'Depth'), imshow(depth_frame);
depth_roi = imcrop(depth_frame,[310 175 width_roi height_roi]);
figure('Name', 'ROI - Depth'), imshow(depth_roi);


% Calculate the mean, standard deviation and SNR
fprintf('- Leap motion ROI information:\n');
leap_motion_double = im2double(rgb2gray(leap_motion_roi));
leap_motion_mean   = mean(leap_motion_double(:));
fprintf('[Mean]\n');
disp(leap_motion_mean);

fprintf('[Standard deviation]\n');
leap_motion_sd   = std(leap_motion_double(:));
disp(leap_motion_sd);

fprintf('[SNR]\n');
disp(leap_motion_mean/leap_motion_sd);


fprintf('- Infrared ROI information:\n');
infrared_double = im2double(rgb2gray(infrared_roi));
infrared_mean   = mean(infrared_double(:));
fprintf('[Mean]\n');
disp(infrared_mean);

fprintf('[Standard deviation]\n');
infrared_sd   = std(infrared_double(:));
disp(infrared_sd);

fprintf('[SNR]\n');
disp(infrared_mean/infrared_sd);


fprintf('- Depth ROI information:\n');
depth_double = im2double(rgb2gray(depth_roi));
depth_mean = mean(depth_double(:));
fprintf('[Mean]\n');
disp(depth_mean);

fprintf('[Standard deviation]\n');
depth_sd   = std(depth_double(:));
disp(depth_sd);

fprintf('[SNR]\n');
disp(depth_mean/depth_sd);