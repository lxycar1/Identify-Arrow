function [imgn,Tinv]=ToRect(varargin)%function varargout = multiple(varargin)
% %%%%%%%imgn=ToRect(Pic)或imgn=ToRect(Pic，FourPoint)%%%[imgn,Tinv]=ToRect('0.jpg',FourPoint);
% %%%%%%%将任意四边形转换为正方形并输出这个截取图像和变换逆矩阵
% %%%%%%Pic为原待处理图像，X为任意四边形顶点的左上、右上、右下、左下的列数，Y为对应行数
% 
% %%%%  nargin为输入参数个数  nargout为输出参数个数
if nargin == 1
     Pic= varargin{1};
elseif nargin ==2
     Pic= varargin{1};
     X=varargin{2}(:,1);
     Y=varargin{2}(:,2);
end;
% img1=imread('00.jpg');nargin=2;X=FourPoint(:,1);Y=FourPoint(:,2);
img1=imread(Pic);
% img=img1;
% if (ndims(img1)==3)
%     img=rgb2gray(img1);%如果是彩色图像，则转为灰度图像??
% end

% if nargin == 2   %%%%%找到不规则区域
%     [BW]=roipoly(img,X,Y);%%代码投入用
% else
%     [BW,X,Y]=roipoly(img);%%代码检测用
% end 
% 
% BW=uint8(BW);
% M=BW.* img; % bw 是二值图像;

% h=max((X(2)-X(1)),(X(3)-X(4)));
h=979;
w=h;%%构建正方形

p1=[X(1),Y(1);X(2),Y(2);X(3),Y(3);X(4),Y(4)];  %左上、右上、右下、左下
p2=[1,1;w,1;w,h;1,h];%%%对应矩形大小

T = maketform('projective', p1, p2);  %投影矩阵
Tinv=T.tdata.Tinv;
% imgn=imtransform(M,T,'XData',[1 w],'YData',[1 h]);     %投影,将灰度图截取投影在H*H的正方形形框中
imgn=imtransform(img1,T,'XData',[1 w],'YData',[1 h]);     %投影,将原图截取投影在H*H的正方形形框中

imshow(imgn),impixelinfo;%%%%%显示出来
