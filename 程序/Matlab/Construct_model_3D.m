close all;
clear all;
clc;

addpath(genpath('D:\同步空间\程序\Matlab\博士后程序\SeisLab_3.02'));

%% 参数
nx = 101; ny = 2; nz = 71;
dx = 1.0; dy = 1.0; dz = 1.0;
x_min = 0.0; y_min = 0.0; z_min = 0.0;
x = x_min: dx: x_min+(nx-1)*dx;
y = y_min: dy: y_min+(ny-1)*dy;
z = z_min: dz: z_min+(nz-1)*dz;

[X,Y,Z]=meshgrid(x,y,z);

%% 建立模型
model = zeros(nz,nx,ny);
model( : , : , : ) = 600.0;
for iy=1:ny
    for ix = (nx-1)/2-2 : (nx-1)/2+3
        for iz = 1 : 50
            model(iz,ix,iy)=6000.0;
        end
    end
end

min_model = min(min(min(model)));
max_model = max(max(max(model)));

%% 画图
% 创建一个新的图形窗口
figure;

% 设置图形窗口尺寸
figure_size = [770, 420];
set(gcf, 'Position', [100, 100, figure_size]);

% 在窗口中创建一个子图
ax = subplot(1, 1, 1);

V = permute(model, [3,2,1]);
xslice = [(nx-1)/2*dx]; yslice = [(ny-1)*dy]; zslice = [(nz-1)/2*dz];

% 画 3D 图
% slic = slice(X,Y,Z,V,xslice,yslice,zslice,'cubic');

% 画 2D 图
slic = slice(X,Y,Z,V,[],yslice,[]);
%---------------------------------
set(gca,'zdir','reverse');
%---------------------------------
% 设置刻度线朝外
set(gca, 'TickDir', 'out');

xlabel('Position (m)'); ylabel('CrossPosition (m)'); zlabel('Depth (m)');

% 使得横、纵坐标之间的间隔一致
axis equal; 

% 设置视图，X-Z 视图
view(0, 0);

% 设置标题的位置
% 获取图形对象的位置信息
pos_figure = get(ax, 'Position');
% 计算标题的位置
title_x = pos_figure(1) + pos_figure(3)/2; % 水平位置居中
title_y = pos_figure(2) + pos_figure(4) + 0.06; % 垂直位置距离上边框合适位置处
% 添加标题
title_str = 'P Wave Velocity';
annotation('textbox', [title_x, title_y, 0, 0], 'String', title_str, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FitBoxToText', 'on', 'LineStyle', 'none');

% 调整刻度数字与刻度线之间的间距
ax.XRuler.TickLabelGapMultiplier = -0.1;
ax.ZRuler.TickLabelGapMultiplier = -0.0;
% ax.YRuler.TickLabelGapMultiplier = -0.0;

% 设置刻度线朝外
set(gca, 'TickDir', 'out');

% 去掉网格
set(slic, 'EdgeColor', 'none');


% 设置 colorbar
cb = colorbar('Limits',[min_model  max_model]);

% set(get(c1,'title'),'string','m/s'); % 备注在 colorbar 的上方
set(get(cb,'ylabel'),'string','m/s','fontsize',11); % 备注在 colorbar 的侧面

% 设置 colorbar 的刻度线朝外
cb.TickDirection = 'out';

% pos_slic = slic.Position;

cb.Position = [pos_figure(1)+pos_figure(3)-0.05  pos_figure(2) 0.03 pos_figure(4)]; % 根据需要调整位置和尺寸

%% 保存图片
% % 获取当前窗口的句柄
% fig = gcf;
% % 使用 getframe 获取当前窗口的图像数据
% frame = getframe(fig);
% % 从截图中获取图像数据
% image_data = frame.cdata;
% 
% % 指定感兴趣区域的位置和大小（左上角的点和矩形的宽度和高度）
% x = 0; % 左上角的 x 坐标
% y = 0; % 左上角的 y 坐标
% width = 100000; % 矩形的宽度
% height = 100000; % 矩形的高度
% 
% % 裁剪选定区域
% cropped_img = imcrop(image_data, [x, y, width, height]);
% 
% % 创建一个新的 Figure
% fig = figure;
% % 创建一个 Axes 对象
% ax = axes(fig);
% % 将裁剪后的图像显示在 Axes 对象上
% imshow(cropped_img, 'Parent', ax);
% 
% % 保存裁剪后的图像为 EPS 格式，并设置 DPI
% dpi = 300; % 设置 DPI（每英寸点数）
% fn_image_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure\P_wave_velocity_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.eps'];
% print(fn_image_output, '-depsc', ['-r' num2str(dpi)]);
% 
% % 或者，可以将裁剪后的图像保存为其他格式（如 PNG），并设置 DPI
% % dpi = 600; % 设置 DPI（每英寸点数）
% % fn_image_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\Figure\P_wave_velocity_nx',num2str(nx),'_nz',num2str(nz),'_dpi',num2str(dpi),'.png'];
% % % 保存图像为 PNG 格式，指定文件名和 DPI 值
% % exportgraphics(ax, fn_image_output, 'Resolution', dpi, 'BackgroundColor', 'none');
% 
% % 关闭 Figure 对象
% close(fig);

%% 输出模型数据
fn_output = ['D:\同步空间\数据\地球物理学\博士后\福建地铁项目\合成数据\P_wave_velocity_nx',num2str(nx),'_nz',num2str(nz),'.dat'];
fp = fopen(fn_output,'w+');
for iy = 1 : 1
    for ix = 1 : nx
        fwrite(fp,model(:,ix,iy),'float32');
    end
end
fclose(fp);