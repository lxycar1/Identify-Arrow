function FourPoint= Fourp(img1)
%%FourPoint= Fourp('0.jpg');
%%%%灰度图，二值化，去边缘白色背景，填充,（编号，中心点位置判断），边缘检测，霍夫直线变换，极坐标转换为直角坐标，交于4点，顺次输出左上、右上、右下、左下坐标点
% clc;clear;close all;
% img=imread('111.JPG');%读入图像
%  img=imread('00.jpg');%读入图像
img=imread(img1);%读入图像
img1=img;%%%%%保留原图可以使用
if (ndims(img1)==3)
    img1=rgb2gray(img1);%如果是彩色图像，则转为灰度图像??
end
I=imadjust(img1,[0.4,0.7],[]);

I=im2bw(I);%转换为二值图片
[m, n]=size(I);

I=imclearborder(I);%%%%清除连接边界区域
I = imfill(I,'holes');%内部填充
[~,nm] = bwlabel(I,8);%区域标识
if nm~=1
    Area=m*n/30;%%%%%%%设置杂点区域面积阈值
    I=bwareaopen(I,Area);%除去小面积百色区域
    centerp=round([m/2 n/2]);%%%%%取图片中心点
    [L,nm] = bwlabel(I,4);%区域标识
    for i=1:nm               %%%%%%%找到包含中心点的区域，成为目标图片
        I0=(L==i);
        if I0(centerp)==1
            I=I0;
            break;
        end
    end
end
I = edge(I,'sobel'); %sobel算子
figure(1),warning('off', 'Images:initSize:adjustingMag'),imshow(img);impixelinfo;%%% 

hold on

%左方直线检测与绘制
%得到霍夫空间上下
[H1,T1,R1] = hough(I,'theta',-90:0.1:89.99);%%输入二值图像I，角度范围与步进（最大，[-90, 90)）,返回 H1霍夫空间，T-theta，R-p)；
%求极值点
Peaks=houghpeaks(H1,4);                 %%%%输入霍夫空间和极值数量，返回极值的坐标
%得到线段信息
Lines=houghlines(I,T1,R1,Peaks);      %%%%%%返回lines是一个包含图像中线段首末点、p、theta的结构体


aa=0;k=zeros(length(Lines)-4,1);%%%%%%%%将rho和theta近乎一致的线段融为一根，最终成为4根线段
for i=1:length(Lines)-1
    if aa==length(Lines)-4
        break;
    elseif ismember(i,k)
        continue;
    end
    for j=i+1:length(Lines)
        if abs(Lines(i).theta-Lines(j).theta)<0.1&&abs(Lines(i).rho-Lines(j).rho)<2
            Lines(i).point2=Lines(j).point2;
            aa=aa+1;
            k(aa)=j;%%%%%得到与前面重复的下标
            if aa==length(Lines)-4
                break;
            end
        end
    end
end
Lines(k)=[];
lines=Lines;

pmin=abs([lines(1).rho lines(2).rho lines(3).rho lines(4).rho]);
sitamin=abs([lines(1).theta lines(2).theta lines(3).theta lines(4).theta]);

[~,B]=sort(pmin);%%%%%%数组重新从小到大排序，B为A中元素在原数列的序号列
[~,D]=sort(sitamin);%%%%%%根据4根线的tho和theta特点标识线

line(1)=lines(intersect(B(1:2),D(3:4)));%%%%上面水平线
line(2)=lines(intersect(B(3:4),D(1:2)));%%%%右边竖直线
line(3)=lines(intersect(B(3:4),D(3:4)));%%%%下面水平线
line(4)=lines(intersect(B(1:2),D(1:2)));%%%%左边竖直线
lines=line;

b=zeros(4);k=zeros(4);
for i=1:4%%%%%%%%%%%%%%%%%%%%依次求出各线的斜率k和截值b
      k(i)=(lines(i).point1(2)-lines(i).point2(2))/(lines(i).point1(1)-lines(i).point2(1));
      b(i)=lines(i).point1(2)-k(i)*lines(i).point1(1);
end
FourPoint=zeros(4,2);
for i=1:4%%%%%%%%%%%%%%%%%%%%依次求出各线的左上、右上、右下、左下交点
    if i==4
     FourPoint(1,1)=(b(1)-b(4))/(k(4)-k(1));
     FourPoint(1,2)=k(1)*FourPoint(1,1)+b(1);
     plot(FourPoint(1,1) ,FourPoint(1,2),'.','MarkerSize',20);%描出最新着箭点
     break;
    end
    FourPoint(i+1,1)=(b(i)-b(i+1))/(k(i+1)-k(i));
    FourPoint(i+1,2)=k(i)*FourPoint(i+1,1)+b(i);
    %plot(FourPoint(i+1,1) , FourPoint(i+1,2),'.','MarkerSize',20);%描出最新着箭点
end
 
qq=zeros(5,2);
qq(1:4,:)=FourPoint;
qq(5,:)=FourPoint(1,:);
%绘制线段
 for k=1:length(lines)
% xy=[lines(k).point1;lines(k).point2];   
% plot(xy(:,1),xy(:,2),'LineWidth',4);
plot(qq(k:k+1,1),qq(k:k+1,2),'LineWidth',4);%%%%%连接4个点成四边形，并绘制
 end

 hold off
