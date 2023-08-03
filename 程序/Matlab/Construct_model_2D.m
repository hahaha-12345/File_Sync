<<<<<<< HEAD
%% 启动计时器，监控程序的运行效率
tic;

%%
close all;
clear all;
clc;

addpath(genpath('D:\同步空间\程序\博士后程序\Matlab\SeisLab_3.02'));

%% 基本参数
nx = 101; nz = 71;
% nx = 301; nz = 301;
dx = 10.0; dz = 10.0;

%% 建立速度模型
model = zeros(nz,nx);
model( : , : ) = 5000.0;
for ix = (nx-1)/2-2 : (nx-1)/2+4
    for iz = 1 : 50
        model(iz,ix)=10000.0;
    end
end

min_model = min(min(model));
max_model = max(max(model));

%% 画图展示

% 创建一个新的图形窗口
figure;

% 设置图形窗口尺寸
figure_size = [555, 345];
set(gcf, 'Position', [100, 100, figure_size]);

% 设置窗口的位置和大小
xpos = 45; ypos = 45;
width = 415; height = 280;

% 在窗口中创建一个子图
ax = subplot(1, 1, 1);

% 设置图的字体为 Calibri
set(groot, 'DefaultAxesFontName', 'Calibri')
set(groot, 'DefaultTextFontName', 'Calibri')

% s_cplot(model);
imagesc(model);

% 设置边框线的宽度
line_width = 1;

% 设置相关参数
set(gca, 'box', 'off',...
         'linewidth',line_width,...
         'TickDir','out',...
         'xlim', [1 nx],...
         'ylim', [1 nz])
% 使得横纵坐标之间的间隔一致
axis equal;
% 设置 x 坐标轴刻度
xlim([1 nx]);
xticks(1:10:nx);
xticklabels(0:10*dx:(nx-1)*dx);
xlabel('Position (dm)');
% 设置 y 坐标轴刻度
ylim([1 nz]);
yticks(1:10:nz);
yticklabels(0:10*dz:(nx-1)*dz);
ylabel('Depth (dm)');

% 调整刻度数字与刻度线之间的间距
ax.XRuler.TickLabelGapMultiplier = 0.0;
ax.YRuler.TickLabelGapMultiplier = 0.0;

title('P Wave Velocity', 'FontWeight', 'bold');
% 设置标题距离上框线的距离为合适位置
title_position = get(gca, 'Title').Position;
title_position(2) = line_width; % 设置合适位置
set(gca, 'Title', title('P Wave Velocity', 'Position', title_position, 'FontWeight', 'bold'));

% 设置 colorbar
cb = colorbar('Limits',[min_model  max_model]);
% set(get(c1,'title'),'string','m/s'); % 备注在 colorbar 的上方
set(get(cb,'ylabel'),'string','dm/s'); % 备注在 colorbar 的右侧面
% 设置 colorbar 的刻度线朝外
cb.TickDirection = 'out';
% 设置 colorbar 的边框线宽度
set(cb, 'LineWidth', line_width);

% 设置图形窗口的位置和大小
fig = gca; % 获取当前图形的句柄
fig.Units = 'pixels'; % 将窗口单位设置为像素
fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]

%% 添加上边和右边的框线

% 方法 1
% 新建坐标区法，添加上边和右边的框线
ax = axes( 'Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k',...
           'YColor','k'); 
% set(ax, 'linewidth',line_width);
set(ax, 'linewidth',line_width,...
        'XTick', [],...
        'YTick', []);    
% 使得横纵坐标之间的间隔一致
axis equal;
% 显示新建坐标轴的范围
axis([1, nx, 1, nz]);

% 设置新坐标区窗口的位置和大小
fig = gca; % 获取新坐标区的句柄
fig.Units = 'pixels'; % 将窗口单位设置为像素
fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]


% 方法 2
% 画线法，添加上边和右边的框线
% hold on
% XL = get(gca,'xlim'); XR = XL(2);
% YL = get(gca,'ylim'); YT = YL(1);
% xc = get(gca,'XColor');
% yc = get(gca,'YColor');
% plot(XL,YT*ones(size(XL)),'color', xc,'linewidth',line_width)
% plot(XR*ones(size(YL)),YL,'color', yc,'linewidth',line_width)
% 
% % 设置新画线图形窗口的位置和大小
% fig = gca; % 获取新画线图形的句柄
% fig.Units = 'pixels'; % 将窗口单位设置为像素
% fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]

%% 保存图片

% 保存图像为.png格式，并设置分辨率为300dpi
dpi = 300; % 设置 DPI（每英寸点数）
file_format = 'png';
fn_save = 'P_wave_velocity';
fn_image_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];
% fn_image_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];

% 如果文件已经存在，则先删除现有文件
% if exist(fn_image_output, 'file')
%     delete(fn_image_output);
% end

print(fn_image_output,['-r',num2str(dpi)],['-d',file_format]);

% 将生成的图片移动到目标文件夹
sourceFolder = 'D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据';   % 源文件夹路径
destinationFolder = 'D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure';   % 目标文件夹路径
fileName = [fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];   % 文件名及扩展名
% 构建源文件的完整路径
sourceFile = fullfile(sourceFolder, fileName);
% 移动文件到目标文件夹
movefile(sourceFile, destinationFolder);

%% 输出模型数据
fn_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'.dat'];
fp = fopen(fn_output,'w+');
for ix = 1 : nx
    fwrite(fp,model(:,ix),'float32');
end
fclose(fp);

%% 停止计时器并输出程序的运行时间
elapsed_time = toc;
=======
%% 启动计时器，监控程序的运行效率
tic;

%%
close all;
clear all;
clc;

addpath(genpath('D:\同步空间\程序\博士后程序\Matlab\SeisLab_3.02'));

%% 基本参数
nx = 101; nz = 71;
% nx = 301; nz = 301;
dx = 10.0; dz = 10.0;

%% 建立速度模型
model = zeros(nz,nx);
model( : , : ) = 5000.0;
for ix = (nx-1)/2-2 : (nx-1)/2+4
    for iz = 1 : 50
        model(iz,ix)=10000.0;
    end
end

min_model = min(min(model));
max_model = max(max(model));

%% 画图展示

% 创建一个新的图形窗口
figure;

% 设置图形窗口尺寸
figure_size = [555, 345];
set(gcf, 'Position', [100, 100, figure_size]);

% 设置窗口的位置和大小
xpos = 45; ypos = 45;
width = 415; height = 280;

% 在窗口中创建一个子图
ax = subplot(1, 1, 1);

% 设置图的字体为 Calibri
set(groot, 'DefaultAxesFontName', 'Calibri')
set(groot, 'DefaultTextFontName', 'Calibri')

% s_cplot(model);
imagesc(model);

% 设置边框线的宽度
line_width = 1;

% 设置相关参数
set(gca, 'box', 'off',...
         'linewidth',line_width,...
         'TickDir','out',...
         'xlim', [1 nx],...
         'ylim', [1 nz])
% 使得横纵坐标之间的间隔一致
axis equal;
% 设置 x 坐标轴刻度
xlim([1 nx]);
xticks(1:10:nx);
xticklabels(0:10*dx:(nx-1)*dx);
xlabel('Position (dm)');
% 设置 y 坐标轴刻度
ylim([1 nz]);
yticks(1:10:nz);
yticklabels(0:10*dz:(nx-1)*dz);
ylabel('Depth (dm)');

% 调整刻度数字与刻度线之间的间距
ax.XRuler.TickLabelGapMultiplier = 0.0;
ax.YRuler.TickLabelGapMultiplier = 0.0;

title('P Wave Velocity', 'FontWeight', 'bold');
% 设置标题距离上框线的距离为合适位置
title_position = get(gca, 'Title').Position;
title_position(2) = line_width; % 设置合适位置
set(gca, 'Title', title('P Wave Velocity', 'Position', title_position, 'FontWeight', 'bold'));

% 设置 colorbar
cb = colorbar('Limits',[min_model  max_model]);
% set(get(c1,'title'),'string','m/s'); % 备注在 colorbar 的上方
set(get(cb,'ylabel'),'string','dm/s'); % 备注在 colorbar 的右侧面
% 设置 colorbar 的刻度线朝外
cb.TickDirection = 'out';
% 设置 colorbar 的边框线宽度
set(cb, 'LineWidth', line_width);

% 设置图形窗口的位置和大小
fig = gca; % 获取当前图形的句柄
fig.Units = 'pixels'; % 将窗口单位设置为像素
fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]

%% 添加上边和右边的框线

% 方法 1
% 新建坐标区法，添加上边和右边的框线
ax = axes( 'Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k',...
           'YColor','k'); 
% set(ax, 'linewidth',line_width);
set(ax, 'linewidth',line_width,...
        'XTick', [],...
        'YTick', []);    
% 使得横纵坐标之间的间隔一致
axis equal;
% 显示新建坐标轴的范围
axis([1, nx, 1, nz]);

% 设置新坐标区窗口的位置和大小
fig = gca; % 获取新坐标区的句柄
fig.Units = 'pixels'; % 将窗口单位设置为像素
fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]


% 方法 2
% 画线法，添加上边和右边的框线
% hold on
% XL = get(gca,'xlim'); XR = XL(2);
% YL = get(gca,'ylim'); YT = YL(1);
% xc = get(gca,'XColor');
% yc = get(gca,'YColor');
% plot(XL,YT*ones(size(XL)),'color', xc,'linewidth',line_width)
% plot(XR*ones(size(YL)),YL,'color', yc,'linewidth',line_width)
% 
% % 设置新画线图形窗口的位置和大小
% fig = gca; % 获取新画线图形的句柄
% fig.Units = 'pixels'; % 将窗口单位设置为像素
% fig.Position = [xpos, ypos, width, height]; % 设置窗口的位置和大小 [xpos, ypos, width, height]

%% 保存图片

% 保存图像为.png格式，并设置分辨率为300dpi
dpi = 300; % 设置 DPI（每英寸点数）
file_format = 'png';
fn_save = 'P_wave_velocity';
fn_image_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];
% fn_image_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];

% 如果文件已经存在，则先删除现有文件
% if exist(fn_image_output, 'file')
%     delete(fn_image_output);
% end

print(fn_image_output,['-r',num2str(dpi)],['-d',file_format]);

% 将生成的图片移动到目标文件夹
sourceFolder = 'D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据';   % 源文件夹路径
destinationFolder = 'D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure';   % 目标文件夹路径
fileName = [fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.',file_format];   % 文件名及扩展名
% 构建源文件的完整路径
sourceFile = fullfile(sourceFolder, fileName);
% 移动文件到目标文件夹
movefile(sourceFile, destinationFolder);

%% 输出模型数据
fn_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\',fn_save,'_nx',num2str(nx),'_nz',num2str(nz),'.dat'];
fp = fopen(fn_output,'w+');
for ix = 1 : nx
    fwrite(fp,model(:,ix),'float32');
end
fclose(fp);

%% 停止计时器并输出程序的运行时间
elapsed_time = toc;
>>>>>>> 2b27bf6 (百度网盘Windows10)
disp(['程序运行时间：', num2str(elapsed_time), '秒']);