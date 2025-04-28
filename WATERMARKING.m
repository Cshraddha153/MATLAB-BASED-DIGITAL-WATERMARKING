clc; clear; close all;

%% === Load and Preprocess ===
host = imread('/MATLAB Drive/host.jpeg');
watermark = imread('/MATLAB Drive/watermark.jpeg');

% Convert to grayscale
if size(host,3) == 3
    host = rgb2gray(host);
end
if size(watermark,3) == 3
    watermark = rgb2gray(watermark);
end

% Resize watermark to match host
watermark_resized = imresize(watermark, [size(host,1), size(host,2)]);

%% === VISIBLE WATERMARKING ===
alpha = 0.3;
visible_watermarked = uint8((1 - alpha) * double(host) + alpha * double(watermark_resized));
figure, imshow(visible_watermarked);
title('Visible Watermarked Image');

%% === INVISIBLE WATERMARKING (LSB) ===

% Convert watermark to binary (0 or 1)
binary_watermark = watermark_resized > 127;


% Convert host to uint8 if needed
host_uint8 = uint8(host);

% Embed binary watermark into LSB
invisible_watermarked = bitset(host_uint8, 1, binary_watermark);  % Embed in LSB

% Save and show
imwrite(invisible_watermarked, 'invisible_watermarked.png');
figure, imshow(invisible_watermarked);
title('Invisible Image');

%% === EXTRACT INVISIBLE WATERMARK ===

% Read image and extract LSB
wm_image = imread('invisible_watermarked.png');
extracted_watermark = bitget(wm_image, 1);  % Gives 0 or 1

% Convert to double for proper visualization
extracted_watermark = double(extracted_watermark);

figure, imshow(extracted_watermark);  % Now will be visible
title('Extracted Watermark Image');