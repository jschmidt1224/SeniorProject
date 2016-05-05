clear all; close all; clc;
original = imread('ping-pong.jpg');

hsvImage = rgb2hsv(original);
%imshow(original);
%figure;

hPlane = 360.*hsvImage(:,:,1);
sPlane = hsvImage(:,:,2);
vPlane = hsvImage(:,:,3);
nonRedIndex = (hPlane > 57) | (hPlane < 10);
nonRedIndex = nonRedIndex | vPlane < .85;
sPlane(nonRedIndex) = 0;
vPlane(nonRedIndex) = vPlane(nonRedIndex);
hsvImage(:,:,2) = sPlane;
hsvImage(:,:,3) = vPlane;
rgbImage = hsv2rgb(hsvImage);

%imshow(rgbImage);

[Centers, Radii] = imfindcircles(rgbImage, [70 2000], 'Sensitivity', .95);
figure;
imshow(rgbImage);
h = viscircles(Centers, Radii);