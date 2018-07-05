function [centers , radii,getim,ym]= findc(imgn)
%%%%%%%%抄的*****构造函数findc对箭靶盘找外圆圆心centers和其半径radii
%%%%%%%%读入ToRect的imgn图片，灰度，二值化，出去边缘黑线，细化到线，找圆和圆心

 img=imgn;%读入图像
 img1=img;
if (ndims(img1)==3)
    img1=rgb2gray(img1);%如果是彩色图像，则转为灰度图像??
end

%%%%%寻找合适阈值，条件是二值化后白色区域面积占整图1/4以上，排除环境色影响
[m,n,~] = size(img1); 
Black=zeros(m);
getim=Black;

S0=m*n/4;
S=0;thresh=0.2;
while S<S0
I=imadjust(img1,[thresh,1-thresh],[]);
I=im2bw(I);%转换为二值图片.
S= bwarea(I);
thresh=thresh+0.05;
end

I=imclearborder(I);%%%%去除边界白色域
I=~I;
I=imclearborder(I);%%%%取反去除边界黑色域
I = imfill(I,'holes');%内部填充(可用来做掩膜！！！！！)
% se=strel('disk',5);
% I=imopen(I,se);
ym=I;
% imshow(I),title('原图') ,impixelinfo;

BW = edge(I,'sobel'); 

step_r = 5; 
step_angle = 0.3; 
r_min = m*0.3; 
r_max = m*0.5; 
thresh = 0.9; 
% %%%%%%%%%%%%%%%%%%%%%%%%%% 
% input 
% BW:二值图像； 
% step_r:检测的圆半径步长 
% step_angle:角度步长，单位为弧度 
% r_min:最小圆半径 
% r_max:最大圆半径 
% p:阈值，0，1之间的数 
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% output 
% hough_space:参数空间，h(a,b,r)表示圆心在(a,b)半径为r的圆上的点数 
% hough_circl:二值图像，检测到的圆 
% para:检测到的圆的圆心、半径 
[m,n] = size(BW); 
size_r = round((r_max-r_min)/step_r)+1; 
size_angle = round(2*pi/step_angle); 
 
hough_space = zeros(m,n,size_r); 
 
[rows,cols] = find(BW); 
ecount = size(rows); 
 
% Hough变换 
% 将图像空间(x,y)对应到参数空间(a,b,r) 
% a = x-r*cos(angle) 
% b = y-r*sin(angle) 
for i=1:ecount 
    for r=1:size_r 
        for k=1:size_angle 
            a = round(rows(i)-(r_min+(r-1)*step_r)*cos(k*step_angle)); 
            b = round(cols(i)-(r_min+(r-1)*step_r)*sin(k*step_angle)); 
            if(a>0&&a<=m&&b>0&&b<=n) 
                hough_space(a,b,r) = hough_space(a,b,r)+1; 
            end 
        end 
    end 
end 
 
% 搜索超过阈值的聚集点 
max_para = max(max(max(hough_space))); 

% while 1%%%%%%%%%%只取一个半径
% index = find(hough_space>=max_para*thresh ); 
% length = size(index); 
% if length==1
%     break;
% end
% thresh=thresh-0.01;
% end
index = find(hough_space>=max_para*thresh ); 
index=max(index);

hough_circle = false(m,n); 
for i=1:ecount 
        par3 = floor(index(1)/(m*n))+1; 
        par2 = floor((index(1)-(par3-1)*(m*n))/m)+1; 
        par1 = index(1)-(par3-1)*(m*n)-(par2-1)*m; 
        if((rows(i)-par1)^2+(cols(i)-par2)^2<(r_min+(par3-1)*step_r)^2+5&&... 
                (rows(i)-par1)^2+(cols(i)-par2)^2>(r_min+(par3-1)*step_r)^2-5) 
            hough_circle(rows(i),cols(i)) = true; 
        end 
end 
 
% 打印检测结果 
    par3 = floor(index(1)/(m*n))+1; 
    par2 = floor((index(1)-(par3-1)*(m*n))/m)+1; 
    par1 = index(1)-(par3-1)*(m*n)-(par2-1)*m; 
    par3 = r_min+(par3-1)*step_r; 
    %fprintf(1,'Center %d %d radius %d\n',par1,par2,par3); %%%显示圆心和半径
    %para(:,k) = [par1,par2,par3]; 
    centers=[par2 par1];%%%%圆心
    radii=par3;%%%%%%%%%%%%%半径
%%%%%%%%%绘图    
imshow(imgn),title('原图') ,impixelinfo;
hold on,viscircles([par2 par1],par3);%画出外圆轮廓
plot(par2,par1,'.','MarkerSize',20);%描出最新着箭点
hold off;
