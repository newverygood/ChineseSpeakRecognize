# 基音周期提取2－基于线性相关系数的Matlab实现

##  基音周期提取结果
![](file:///E:/SpeakRecognize/语音0-10Pth_OK.png)  
图1  基音提取结果

##  算法说明  
###  线性相关系数  
    也称“皮尔逊积矩相关系数”（Pearson product-moment correlation coefficient）

    通常用γ或ρ表示，是用来度量两个变量之间的相互关系（线性相关），取值范围在[-1，+1]之间。

    γ＞0为正相关，γ＜0为负相关，γ＝0表示不相关。γ的绝对值越大，相关程度越高。

    两个现象之间的相关程度，一般划分为四级：

    r=1时为完全正相关；如两者呈负相关则r呈负值，而r=-1时为完全负相关。当例数相等时，相关系数的绝对值越接近1，相关越密切；当r=0时，说明X和Y两个变量之间无线性关系。通常|r|大于0.75时，认为两个变量有很强的线性相关性。

 
![](file:///E:/SpeakRecognize/corrcoef.png)
图2  线性相关系数计算公式 

    式中x,y为两个向量，这里理解为两帧语音的采样序列。当x,y为相邻的两帧数据，且帧长等于基音周其时，其相关系数为最大值(最接近1)。

###  Matlab应用编程  
    Matlab中可用corrcoef(x,y)函数计算相关系数。

```
%inx:     输入的语音采样数据
%Pos:     查找Pos点处的基音周期
%minpth:  基音周期最小值对应的采样点数
%maxpth:  基音周期最大值对应的采样点数
%plotfig: 为1时绘制计算过程曲线图
%
%out:       以不同样点数作为期音周期的相似系数，其最大值点就对应基音周期
function [out] = findPitchCorrcoef(inx,Pos,minpth,maxpth,plotfig)
[line,row] = size(inx);
out = 0;
if(line<Pos+ceil(maxpth))
    return;
end
if(Pos<ceil(maxpth))
    return;
end
out=zeros(ceil(maxpth),1);
for i=floor(minpth):ceil(maxpth)
    xa = inx(Pos-i:Pos);        %以i为帧长，Pos点为分界，取其前后两帧数据
    xb = inx(Pos+1:Pos+1+i);
    if(max(abs(xa))<0.05)       %为减小计算量，幅度小于0.05时认为是噪音，不作计算
        continue;
    end
    if(max(abs(xb))<0.05)
        continue;
    end
    corrcoefxab = corrcoef(xa,xb);
    out(i)=corrcoefxab(2,1);
end
if(plotfig == 1)				%绘计算过程曲线
    figure;
    subplot(2,1,1);
    plot(inx,'.-');
    grid on;
    subplot(2,1,2);
    plot(out,'*-');
    grid on;    
end
```
![](file:///E:/SpeakRecognize/基于自相关系数的基音周期计算.png)
图3  基音计算过程曲线

    由图3可以看出，在帧长为42点时(8K采样，对应190.5Hz),相邻两帧语音具有最大相似系数0.9359。而且帧长41点和43点时对应的相似系数小于0.7，对比可知  __基于基于线性相关系数的基音周期计算具有优秀的分辨能力__ 。  
    
    图3右侧对50Hz的工频噪音作基音提取，帧长158点对应50.6Hz也非常准确。

    改变findPitchCorrcoef函数的Pos参数并取输出最大值对应的帧长，即可计算语音数据在各点处的基音周期。如图1。    



