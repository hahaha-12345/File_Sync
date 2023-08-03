%% 启动计时器，监控程序的运行效率
tic;

%%
close all;
clear all;
clc;

addpath(genpath('D:\同步空间\程序\博士后程序\Matlab\SeisLab_3.02'));

%% 制作动图

% 创建一个图形窗口
figure;

% 设置图形窗口尺寸
figure_size = [405, 286];
set(gcf, 'Position', [80, 80, figure_size]);

% 设置窗口的位置和大小
xpos = -4; ypos = 4;
width = 415; height = 280;

% 在窗口中创建一个子图
ax = subplot(1, 1, 1);

% 设置背景色为白色
set(gcf, 'Color', 'white');

% 设置图形窗口的位置和大小
fig = gca; % 获取当前图形的句柄
fig.Units = 'pixels'; % 将窗口单位设置为像素
fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]

% 基本参数
nx = 101; nz = 71; nt = 2000;
% 设置文件夹路径和文件名前缀
folder = 'E:\data\model_data\2D\福建地铁项目\snapshot\1\';
filename_prefix = 'iso_P_wave_snapshot_';
% 获取文件夹中的文件列表
file_list = dir([folder, filename_prefix, '*.dat']);
% 创建一个空的 cell 数组来存储动图的每一帧
frames = cell(1, numel(file_list));
% 播放 frame 的间隔
dframe = 1;
% 播放 frame 的长度
lframe = 800; %numel(file_list);
% 遍历文件列表，读取每个数据文件并生成帧，制作动图
for it = 1:dframe:lframe
    
    % 读取当前数据文件
    file_path = [folder, filename_prefix, num2str(it), '.dat'];
    fid = fopen(file_path, 'rb');
    [row_array, ~] = fread(fid, 'float32');
    data = reshape(row_array, nz, nx);
    fclose(fid);
    
    % 绘制波场快照
    scale = 10;
    resized_data = imresize(data, [nz*scale, nx*scale]); % 调整图像大小
    imagesc(resized_data);

    colormap gray;
    % 设置colorbar范围
    caxis([-1, 1]);

    % 不显示刻度
    box on;
    
    % 设置边框线的宽度
    line_width = 1;
    
    % 设置边框线宽
    set(gca, 'LineWidth', line_width);
    
    % 设置刻度线的长度为 0
    set(gca, 'TickLength', [0  0]);
    
	% 使得横纵坐标之间的间隔一致
    axis equal;
    
    xlim([1 nx*scale]);
    ylim([1 nz*scale]);

    % 隐藏 x 轴的刻度数字
    set(gca, 'XTickLabel', []);
    % 隐藏 y 轴的刻度数字
    set(gca, 'YTickLabel', []);

    % 将当前图像保存为动画帧
    frames{it} = getframe(gcf);
    
end

%% 保存动图

% 保存图像为.png格式，并设置分辨率为300dpi
dpi = 300; % 设置 DPI（每英寸点数）
file_format = 'gif';

% 设置 GIF 的文件名和延迟时间
fn_save = 'P_wave_snapshots';
fn_gif_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];
delay_time = 0.0;

% 将图像帧保存为 GIF 动画
for i = 1:dframe:lframe
    
    % 将结构体转换为图像数据
    frame_data = frames{i};
    im = frame2im(frame_data);
    
    % 调整图像大小以设置DPI
    im = imresize(im, dpi/72);
    
    % 将图像转换为索引图像
    [imind, cmap] = rgb2ind(im, 256);
    
    % 在第一帧时创建 GIF 文件，之后追加帧
    if i == 1
        imwrite(imind, cmap, fn_gif_output, 'gif', 'DelayTime', delay_time, 'Loopcount', 0);
    else
        imwrite(imind, cmap, fn_gif_output, 'gif', 'DelayTime', delay_time, 'WriteMode', 'append');
    end
    
    % 在每一帧之间添加一定的延迟（以减小间隔感）
%     pause(delay_time);

    % 绘制图像
    drawnow;
    
end

% 提示动图生成完成
disp('动图生成完成！');

% 将生成的动图移动到目标文件夹
sourceFolder = 'D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据';   % 源文件夹路径
destinationFolder = 'D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure';   % 目标文件夹路径
fileName = [fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];   % 文件名及扩展名
% 构建源文件的完整路径
sourceFile = fullfile(sourceFolder, fileName);
% 移动文件到目标文件夹
movefile(sourceFile, destinationFolder);

%% 停止计时器并输出程序的运行时间
elapsed_time = toc;
disp(['程序运行时间：', num2str(elapsed_time), '秒']);