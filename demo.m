% Authors: E. Ulises Moya-Sánchez, Bonell Manjarrez Marcela
% Date: July 2015

clear all; close all;

% Read orignal video
original_video = VideoReader('data/1-original.avi');
frame_rate_original = original_video.FrameRate;
fprintf('Frame rate in original: %.2f\n', frame_rate_original);

% Read magnified video
magnified_video = VideoReader('data/1-magnified.avi');
frame_rate_magnified = magnified_video.FrameRate;
fprintf('Frame rate in magnified: %.2f\n', frame_rate_magnified);

start_index = 1;
width_roi   = 80;
height_roi  = 80;
x_roi       = 170;
y_roi       = 200;

% Show the first frame and the ROI
%first_frame = read(original_video, start_index);
%imshow(first_frame);
%original_roi = imcrop(first_frame,[x_roi y_roi width_roi height_roi]);
%figure('Name', 'ROI'), imshow(original_roi);

frames_per_second = round(frame_rate_original);
seconds = 20;
total_frames = frames_per_second * seconds;
frames_frecuency = frames_per_second / 2;
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

figure('Name', 'Difference between original and magnified ROI');

% Calculate mean, stardard deviation and SNR in the videos every 0.5 seconds (every 3 frames)
% Draw the difference (original vs magnified) per frame
for i = start_index: total_frames
 
 original_frame = read(original_video, i);
 original_roi   = rgb2gray(imcrop(original_frame,[x_roi y_roi width_roi height_roi]));
 original_double_roi = im2double(original_roi);
 
 magnified_frame = read(magnified_video, i);
 magnified_roi = rgb2gray(imcrop(magnified_frame,[x_roi y_roi width_roi height_roi]));
 magnified_double_roi = im2double(magnified_roi);
 
    subplot(1,3,1);
    imshow(original_roi);
    title('Original');
    
    subplot(1,3,2);
    imshow(magnified_roi);
    title('Magnified');

    subplot(1,3,3)
    difference_roi = original_roi - magnified_roi;
    imshow(difference_roi,[]);
    title('Difference');
    
    drawnow;
    
         original_mean                  = original_mean + mean(original_double_roi(:));
         original_standard_deviation    = original_standard_deviation + std(original_double_roi(:));

         magnified_mean                 = magnified_mean + mean(magnified_double_roi(:));
         magnified_standard_deviation   = magnified_standard_deviation + std(magnified_double_roi(:));
 
 
        if mod(i, frames_frecuency) == 0
            fprintf('\nSecond %.1f (Original vs Magnified):\n',i/frames_per_second);
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
figure('Name', 'Time vs Intensity');
plot(range_checkpoints, original_intensity, 'g-*', range_checkpoints, magnified_intensity, 'r-*');
title('Time vs Intensity');
xlabel('Seconds');
ylabel('Intensity');
legend('Original','Magnified');

% Draw the standard deviation
figure('Name', 'Time vs Error');
plot(range_checkpoints, original_error, 'y-*', range_checkpoints, magnified_error, 'r-*');
title('Time vs Error');
xlabel('Seconds');
ylabel('Error');
legend('Original','Magnified');

% Draw the SNR
figure('Name', 'Time vs SNR');
plot(range_checkpoints, original_snr, 'b-*', range_checkpoints, magnified_snr, 'r-*');
title('Time vs SNR');
xlabel('Seconds');
ylabel('SNR');
legend('Original','Magnified'); 