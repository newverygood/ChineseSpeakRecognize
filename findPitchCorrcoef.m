%inx:       输入的语音采样数据
%Pos:       查找Pos点处的基音周期
%minpth:  基音周期最小值对应的采样点数
%maxpth:  基音周期最大值对应的采样点数
%plotfig:   为1时绘制输出曲线图
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
    xa = inx(Pos-i:Pos);           %以i为帧长，Pos点为分界，取其前后两帧数据
    xb = inx(Pos+1:Pos+1+i);
    if(max(abs(xa))<0.005)       %为减小计算量，幅度小于0.04时认为是噪音，不作计算
        continue;
    end
    if(max(abs(xb))<0.005)
        continue;
    end
    corrcoefxab = corrcoef(xa,xb);
    out(i)=corrcoefxab(2,1);
end
if(plotfig == 1)
    figure;
    subplot(2,1,1);
    plot(inx,'.-');
    grid on;
    subplot(2,1,2);
    plot(out,'*-');
    grid on;    
end


