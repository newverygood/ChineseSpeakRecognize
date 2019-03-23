%matlab 2016a
%specgram_sw.m
%需要先安装语音处理工具箱(matlab_voicebox)


[Y,FS,WMODE,FIDX]=readwav('sound0_10','s',-1,-1);
    %Y为读到的双声道数据
    %FS为采样频率
    %这里的输入参数sound0_10为双声道数字0到10的声音文件(sound0_10.wav)
    %其它参数的功能忘了

Y1 = Y(:,1);        %Y为双声道数据，取第2通道
plot(Y1);           %画Y1波形图
grid on;
specgram(Y1,2048,44100,2048,1536);
    %Y1为波形数据
    %FFT帧长2048点(在44100Hz频率时约为46ms)
    %采样频率44.1KHz
    %加窗长度，一般与帧长相等
    %帧重叠长度，此处取为帧长的3/4