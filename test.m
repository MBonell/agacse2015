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
width_orginal   = original_video.Width;

frame_rate_original     = original_video.FrameRate;
number_frames_original  = original_video.NumberOfFrames;

%fprintf('Frame rate in original: %d\n', frame_rate_original);
%fprintf('Number of frames in original: %d\n', number_frames_original);

start_index = 1;
end_index   = number_frames_original;

width_roi   = 80;
height_roi  = 80;
x_roi       = 170;
y_roi       = 200;

% Show the first frame and the ROI
first_frame = read(original_video, start_index);
original_roi = imcrop(first_frame,[x_roi y_roi width_roi height_roi]);
imshow(first_frame), figure, imshow(original_roi)

total_frames = 24 * 8;
frames_frecuency = 12;
seconds = total_frames / 24;
checkpoint = 1;
total_checkpoints = total_frames / frames_frecuency;
range_checkpoints = 0.5:0.5:seconds;

original_mean = 0;
original_standard_deviation = 0;
magnified_mean = 0;
magnified_standard_deviation = 0;

original_intensity  = zeros(1,total_checkpoints);
original_error      = zeros(1,total_checkpoints);
original_snr        = zeros(1,total_checkpoints);
magnified_intensity = zeros(1,total_checkpoints);
magnified_error     = zeros(1,total_checkpoints);
magnified_snr       = zeros(1,total_checkpoints);


% Calculate mean, stardard deviation and SNR in the videos every 0.5
% seconds (every 12 frames)
for i = start_index: total_frames
 
 original_frame = read(original_video, i);
 original_roi   = rgb2gray(imcrop(original_frame,[x_roi y_roi width_roi height_roi]));
 original_double_roi = im2double(original_roi);
 
 magnified_frame = read(magnified_video, i);
 magnified_roi = rgb2gray(imcrop(magnified_frame,[x_roi y_roi width_roi height_roi]));
 magnified_double_roi = im2double(magnified_roi);
 
 
 original_mean                  = original_mean + mean(original_double_roi(:));
 original_standard_deviation    = original_standard_deviation + std(original_double_roi(:));
 
 magnified_mean                 = magnified_mean + mean(magnified_double_roi(:));
 magnified_standard_deviation   = magnified_standard_deviation + std(magnified_double_roi(:));
 
 
    if mod(i, frames_frecuency) == 0
        fprintf('\nSecond %.1f (Original vs Magnified):\n',i/24);
        fprintf('[Mean]\n');
        disp(original_mean/frames_frecuency);
        disp(magnified_mean/frames_frecuency);

        fprintf('[Standard deviation]\n');
        disp(original_standard_deviation/frames_frecuency);
        disp(magnified_standard_deviation/frames_frecuency);

        fprintf('[SNR]\n');
        disp((original_mean/original_standard_deviation)/frames_frecuency);
        disp((magnified_mean/magnified_standard_deviation)/frames_frecuency);
        
            original_intensity(checkpoint)  = original_mean/frames_frecuency;
            original_error(checkpoint)      = original_standard_deviation/frames_frecuency;
            original_snr(checkpoint)        = (original_mean/original_standard_deviation)/frames_frecuency;

            magnified_intensity(checkpoint) = magnified_mean/frames_frecuency;
            magnified_error(checkpoint)     = magnified_standard_deviation/frames_frecuency;
            magnified_snr(checkpoint)       = (magnified_mean/magnified_standard_deviation)/frames_frecuency;

            checkpoint = checkpoint + 1;

            original_mean = 0;
            original_standard_deviation = 0;
            magnified_mean = 0;
            magnified_standard_deviation = 0;
    end
 
end 


% Draw the intensity
figure;
plot(range_checkpoints, original_intensity, 'g-*', range_checkpoints, magnified_intensity, 'r-*');
title('Time vs Intensity');
xlabel('Seconds');
ylabel('Intensity');
legend('Original','Magnified');

% Draw the standard deviation
figure;
plot(range_checkpoints, original_error, 'y-*', range_checkpoints, magnified_error, 'r-*');
title('Time vs Error');
xlabel('Seconds');
ylabel('Error');
legend('Original','Magnified');

% Draw the SNR
figure;
plot(range_checkpoints, original_snr, 'b-*', range_checkpoints, magnified_snr, 'r-*');
title('Time vs SNR');
xlabel('Seconds');
ylabel('SNR');
legend('Original','Magnified');
 