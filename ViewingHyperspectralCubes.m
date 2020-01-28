
load illum_25000.mat;     %% illumination dataset 1
load illum_4000.mat;      %% illumination dataset 2
load illum_6500.mat;      %% illumination dataset 3
load ref4_scene4.mat;     %% reference reflectance data
load xyzbar.mat;

%%% The datacube is a dataset I found on the internet. I don't remember the
%%% source.(Please don't sue me) :). Credits to whoever acquired the data.




%%% A test sample of the data cube. Change 17 to whatever part of spectrum
%%% is required. The reference file has reflectance data. Matrix 17 is just an
%%% example I took to view it. (Should generalise it for the final version)
ref = reflectances(:,:,17);
figure(1); 
imshow(ref); colormap('gray'); brighten(0.5);  %% we are brightening the image to compensate(roughly) for gamma of monitor(Accuracy Max). (Just something I found on the internet).



%%% illum_25000 has test illumination data. So multiplying each reflectance data
%%% scence with illumination will give radiance
radiances_25000 = zeros(size(reflectances)); % initialize array
for i = 1:33
  radiances_25000(:,:,i) = reflectances(:,:,i)*illum_25000(i);
end
radiance_25000 = squeeze(radiances_25000(141, 75, :));
figure(2); plot(400:10:720, radiance_25000, 'b'); % blue curve
xlabel('wavelength, nm');
ylabel('radiance, arbitrary data(so arbitrary units:))');
hold on;



%%% this will give radiance values if illumination is according to
%%% illumination file 2
radiances_4000 = zeros(size(reflectances)); % initialize array
for i = 1:33
  radiances_4000(:,:,i) = reflectances(:,:,i)*illum_4000(i);
end
radiance_4000 = squeeze(radiances_4000(141, 75, :));
plot(400:10:720, radiance_4000, 'r'); % red curve

%%% the above snippet of code will give a graph of radiance data. The
%%% radiance data will determine how the actual image will look like.



%%% Now that we have radiance data, the task is to actually get tristimulus CIE and sRGB
%%% representations. For now, lets take illum_6500 data.

radiances_6500 = zeros(size(reflectances)); % initialize array
for i = 1:33
  radiances_6500(:,:,i) = reflectances(:,:,i)*illum_6500(i);
end
radiance = radiances_6500;
[r,c,w] = size(radiance);
radiance = reshape(radiance, r*c, w);

XYZ = (xyzbar'*radiance')';

XYZ = reshape(XYZ, r, c, 3);
XYZ = max(XYZ, 0);
XYZ = XYZ/max(XYZ(:));  %%% Normalization of the values



%%% the reshaping of the matrix has been done so that I could use the
%%% following function. My best guess as to why the function requires this
%%% is because it wants normal 2-D images with three planes rather than a
%%% matrix of 3 columns.
RGB = XYZ2sRGB_exgamma(XYZ); %%% This is just a function I found on the web. I don't know how to cite this in GitHub.



%%% Making the value range as 0-1. Normalization is fun :)
RGB = max(RGB, 0);
RGB = min(RGB, 1);

figure(3); imshow(RGB.^0.4, 'Border','tight');



%%% I realised that the image appears quite dark. I don't know the reason
%%% for this. Probably because of arbitrary radiance data. So for aesthetic
%%% purposes I tried to clip the entire brightness to the max lit pixel of
%%% initial image
z = max(RGB(244,17,:));
RGB_clip = min(RGB, z)/z;
figure(4); imshow(RGB_clip.^0.4, 'Border','tight');           %%% 0.4 to compensate for gamma of monitor.

%%% this code is just viewing hyperspectral data cubes. Hopefully I'll be
%%% able to manipulate this data as situation demands






