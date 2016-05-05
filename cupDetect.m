clear all; close all; clc;
original = imread('output-060.png');

hsvImage = rgb2hsv(original);
%imshow(original);
%figure;
sizeof = size(hsvImage);
xSize = sizeof(1);
ySize = sizeof(2);
hPlane = 360.*hsvImage(:,:,1);
sPlane = hsvImage(:,:,2);
vPlane = hsvImage(:,:,3);
nonRedIndex = (hPlane > 30) & (hPlane < 200);
nonRedIndex = nonRedIndex | vPlane < .4;
nonRedIndex = nonRedIndex | sPlane < .6;
sPlane(nonRedIndex) = 0;
vPlane(nonRedIndex) = 0;%vPlane(nonRedIndex);
hsvImage(:,:,2) = sPlane;
hsvImage(:,:,3) = vPlane;
rgbImage = hsv2rgb(hsvImage);

imshow(rgbImage);
hold on;
Loc = [0, 0];
for y = size(sPlane, 1):-1:1
    for x = 1:size(sPlane, 2)
        if (sPlane(y,x) ~= 0 && sPlane(y+1, x) ~= 0 && sPlane(y+2, x) ~= 0)
            Loc = [x, y];
            break
        end
    end
    if (Loc ~= [0, 0])
        break;
    end
end


plot(Loc(1), Loc(2), 'go', 'MarkerSize', 20)
