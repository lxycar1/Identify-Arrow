function [centers , radii]= findcir(f)
%%%%构造函数对箭靶盘找外圆圆心centers0和其半径radii0
%%%%%%%自己写的
% I0=imread('0.JPG');

% I0=f;
if ischar(f)
    I0=imread(f);
else
    I0=f;
end

if (ndims(I0)==3)
    I0=rgb2gray(I0);%如果是彩色图像，则转为灰度图像??
end

% z=size(size(I0));
% if z>2
% I0=rgb2gray(I0);
% end

I=im2bw(I0);%转换为二值图片
I = imfill(~I,'holes');%内部填充

%%%%regionprops找圆
stats = regionprops(I,'Centroid','MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;

diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

%%%%%显示图片
figure;
imshow(I0);impixelinfo;
title('Filled Image');
hold on%%%显示圆
viscircles(centers,radii);
plot(centers(1),centers(2),'.','MarkerSize',20);
hold off
