function [ output_arg ] = PreProcessBall( input_arg )
%PREPROCESSBALL Preprocess an image for ping pong ball tracking
%   Removes all colors from the image other than the orange of a ping pong
%   ball

hsvImage = rgb2hsv(input_arg);
hPlane = 360.*hsvImage(:,:,1);
sPlane = hsvImage(:,:,2);
vPlane = hsvImage(:,:,3);
nonRedIndex = (hPlane > 54) | (hPlane < 18);
nonRedIndex = nonRedIndex | (sPlane < .3);
nonRedIndex = nonRedIndex | (vPlane < .95);
sPlane(nonRedIndex) = 0;
vPlane(nonRedIndex) = vPlane(nonRedIndex) / 20;
hsvImage(:,:,2) = sPlane;
hsvImage(:,:,3) = vPlane;
output_arg = hsv2rgb(hsvImage);


end

