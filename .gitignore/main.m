clear;clc;
filedir='F:\Files\MATLAB\箭靶406\pic\';%选择图片路径
finf = dir(strcat(filedir,'*.jpg')); %打开文件夹下的jpg文件
allnm = length(finf);  %总数量

FourPoint= Fourp([filedir,finf(1).name]);%%%%%%%%%%%%%找箭靶盘四个角点
[imgn,Tinv]=ToRect([filedir,finf(1).name],FourPoint);%%%%%%%%%%%%%四点转换为正方形
[centers , radii,getim,ym]= findc(imgn);%找箭靶圆心和最外圆半径
number=0;%%射箭次数
a=[0,0];%%%初始着箭点
ZO=getim;
for ii=1:allnm
%     imshow([filedir,finf(ii).name]);
%      pause(2);%%延时0.1s查看
%      continue;
    [A,Tinv]=ToRect([filedir,finf(ii).name],FourPoint);%%%%%%%%%%%%%四点转换为正方形
    [k,yes,getim]=findpR(A,getim,ym);%找着箭点位置
    se=strel('disk',3);
    ZOO=imdilate(ZO,se);%%%%%%%虚拟箭靶扩大点
    %%%%%%对箭是否上靶判断
    if yes==0||ZOO(k(1),k(2))==1
        continue;%%%%箭靶上未发现情况，继续下一个循环
    elseif yes==2
        continue;%%%%应请求支持
    else
        
        number=number+1;%%记录射箭次数
        a=k;
        %%%%%绘图
        figure(1),warning('off', 'Images:initSize:adjustingMag'),imshow(A),impixelinfo;%显示最新图片
        hold on;
        viscircles(centers,radii);%画出外圆轮廓
        plot(a(1),a(2),'.','MarkerSize',20);%描出最新着箭点
        plot(centers(1),centers(2),'.','MarkerSize',20);%描出圆心
        hold off;
        ZO(a(1),a(2))=1;%%%%%虚拟箭靶置为1
        %%%%%确定环数
        r=radii*[0.2 0.4 0.6 0.8 1];
%         L=sqrt((centers(1)-a(1))^2+(centers(2)-a(2))^2);%着箭点离圆心的距离
        L=norm(centers-a);%着箭点离圆心的距离(欧式距离）
        result=0;%重置结果
        for i=1:5
            if  L<r(i)
                result=i;
                break;
            end
        end
        %fprintf('%s will be %d this year.\n',name,age);
        
        %%%%显示结果
        if result~=0
            fprintf('第 %s 次射中的环数是： %d 环！\n',int2str(number),result);%显示环数
        else
            fprintf('第 %d 次射未射中！\n',number);%显示结果
        end
        
        pause(0.1);%%延时0.1s查看
    end
    
end
