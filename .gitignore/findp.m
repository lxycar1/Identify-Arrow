function [k,yes,newim]= findp(A,getim,ym) 
% %%返回着箭点的行列，k(1)为列k(2)行，yes返回箭是否上靶子的信息，yes=1时为真,表示有箭上靶，newim为该次保存的有稳定箭身的二值图；
% %%%函数目的是找到着箭点,A为前面图片，getim为上一个稳定的着箭图,ym为掩膜

%%%

for i=1:1
R1=rgb2gray(A);
% II=imread('01.jpg');
% R1=rgb2gray(II);
bw= im2bw(R1, 0.15); %求二值图
se=strel('disk',2);
bw=imdilate(bw,se);
%warning('off', 'Images:initSize:adjustingMag');imshow(bw);impixelinfo;%%%
bw=~bw;
r1=imclearborder(bw);%%%%取反去除边界黑色域
bw=bw-r1;%%%%%%%%%挑出箭体区域
bw1=bw.*ym;%%%%%圈内
se=strel('disk',80);
my=imerode(~ym,se);
bw2=my.*bw;%%%%%圈外
bw2=bwareaopen(bw2,50);%除去小面积百色区域
warning('off', 'Images:initSize:adjustingMag');imshow(bw1);impixelinfo;%%% 
RR=bw1+bw2;       

S= bwarea(RR);
s=bwarea(getim);
A=S-s;
if A<2000
    yes=0;  
    newim=getim;
    k=[1,1];
    break;
end
newim=RR;%%%当前图赋给newim
yes=1;   

se=strel('disk',2);
getim=imdilate(getim,se);

IA=bw1-getim;%%%%%%%圈内
IB=bw2-getim;%%%%%%%圈外

IA=bwmorph(IA,'thin',Inf);%细化算法，在最初二值图上RR细化箭体得到一个像素宽度线条
IB=bwmorph(IB,'thin',Inf);
% figure(3),imshow(I);impixelinfo;
g1=endpoints(IA);%%得到圈内曲线端点
g2=endpoints(IB);%%得到圈外曲线端点

[y,x]=find(g1==1);
[nm,~]=size(x);%环内点的数量
[Y,X]=find(g2==1);
l=0;
%k=[0,0];
for ii=1:nm
    L=(x(ii)-X(1))^2+(y(ii)-Y(1))^2;
    if L>l
        l=L;
        k=[x(ii),y(ii)];
    end
end
end
