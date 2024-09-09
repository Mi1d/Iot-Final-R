figure;
hold on;

% 定义新的路宽
lane_width = 2.5;

% 绘制四个灰色区域，代表建筑或路外区域
fill([-20 -20 -10 -10], [20 10 10 20], [0.8 0.8 0.8]); % 左上角
fill([10 10 20 20], [20 10 10 20], [0.8 0.8 0.8]); % 右上角
fill([-20 -20 -10 -10], [-20 -10 -10 -20], [0.8 0.8 0.8]); % 左下角
fill([10 10 20 20], [-20 -10 -10 -20], [0.8 0.8 0.8]); % 右下角

% 黑色实线表示道路边界
plot([-20 20], [lane_width*2 lane_width*2], 'k', 'LineWidth', 2); % 顶部边界
plot([-20 20], [-lane_width*2 -lane_width*2], 'k', 'LineWidth', 2); % 底部边界
plot([lane_width*2 lane_width*2], [-20 20], 'k', 'LineWidth', 2); % 右侧边界
plot([-lane_width*2 -lane_width*2], [-20 20], 'k', 'LineWidth', 2); % 左侧边界

% 黄色虚线分隔相向车道，路口中央不画
plot([0 0], [lane_width*2 20], '--', 'Color', [1 0.843 0], 'LineWidth', 2); % 顶部黄线（纵向）
plot([0 0], [-20 -lane_width*2], '--', 'Color', [1 0.843 0], 'LineWidth', 2); % 底部黄线（纵向）
plot([-20 -lane_width*2], [0 0], '--', 'Color', [1 0.843 0], 'LineWidth', 2); % 左侧黄线（横向）
plot([lane_width*2 20], [0 0], '--', 'Color', [1 0.843 0], 'LineWidth', 2); % 右侧黄线（横向）
% 黑色虚线分隔同向两车道，路口中央不画虚线
plot([-20 -lane_width*2], [lane_width lane_width], '--k', 'LineWidth', 1); % 顶部左侧虚线
plot([lane_width*2 20], [lane_width lane_width], '--k', 'LineWidth', 1);   % 顶部右侧虚线
plot([-20 -lane_width*2], [-lane_width -lane_width], '--k', 'LineWidth', 1); % 底部左侧虚线
plot([lane_width*2 20], [-lane_width -lane_width], '--k', 'LineWidth', 1);   % 底部右侧虚线
plot([lane_width lane_width], [lane_width*2 20], '--k', 'LineWidth', 1); % 右侧顶部虚线
plot([lane_width lane_width], [-20 -lane_width*2], '--k', 'LineWidth', 1);  % 右侧底部虚线
plot([-lane_width -lane_width], [lane_width*2 20], '--k', 'LineWidth', 1); % 左侧顶部虚线
plot([-lane_width -lane_width], [-20 -lane_width*2], '--k', 'LineWidth', 1);  % 左侧底部虚线

% 绘制直行路径
straight_paths = {
    [-10, -1.25], [10, -1.25];    % 直行
    [-10, -3.75], [10, -3.75];    % 直行
    [1.25, -10], [1.25, 10];      % 直行
    [3.75, -10], [3.75, 10];      % 直行
    [10, 1.25], [-10, 1.25];      % 直行
    [10, 3.75], [-10, 3.75];      % 直行
    [-1.25, 10], [-1.25, -10];    % 直行
    [-3.75, 10], [-3.75, -10];    % 直行
};

for i = 1:size(straight_paths, 1)
    start_pos = straight_paths{i, 1};
    end_pos = straight_paths{i, 2};
    plot([start_pos(1), end_pos(1)], [start_pos(2), end_pos(2)], 'b', 'LineWidth', 2);
end

% 绘制拐弯路径
turn_paths = {
    [1.25, -10], [1.25, -5], [-5, 1.25], [-10, 1.25], [-5, -5];  % 左
    [3.75, -10], [3.75, -5], [5, -3.75], [10, -3.75], [5, -5];  % 右
    [-10, -1.25], [-5, -1.25], [1.25, 5], [1.25, 10], [-5, 5];  % 左
    [-10, -3.75], [-5, -3.75], [-3.75, -5], [-3.75, -10], [-5, -5]; % 右
    [10, 1.25], [5, 1.25], [-5, -1.25], [-10, -1.25], [5, -5];  % 左
    [10, 3.75], [5, 3.75], [3.75, 5], [3.75, 10], [5, 5];       % 右
    [-1.25, 10], [-1.25, 5], [5, -1.25], [10, -1.25], [5, 5];   % 左
    [-3.75, 10], [-3.75, 5], [-5, 3.75], [-10, 3.75], [-5, 5];  % 右
};

for i = 1:size(turn_paths, 1)
    start_pos = turn_paths{i, 1};
    mid_point1 = turn_paths{i, 2};
    mid_point2 = turn_paths{i, 3};
    end_pos = turn_paths{i, 4};
    center = turn_paths{i, 5};

    plot([start_pos(1), mid_point1(1)], [start_pos(2), mid_point1(2)], 'b', 'LineWidth', 2);

    % 画四分之一圆弧
    r = norm(mid_point1 - center);
    theta1 = atan2(mid_point1(2)-center(2), mid_point1(1)-center(1));
    
    % 确保右转路径为顺时针方向
    if mod(i, 2) == 0  % 对于右转路径
        theta2 = theta1 - pi/2;  % 顺时针方向
        if theta2 < -pi
            theta2 = theta2 + 2 * pi;  % 环绕角度调整
        end
    else  % 对于左转路径
        theta2 = theta1 + pi/2;  % 左转为逆时针方向
    end

    theta = linspace(theta1, theta2, 100);
    arc_x = center(1) + r * cos(theta);
    arc_y = center(2) + r * sin(theta);
    plot(arc_x, arc_y, 'b', 'LineWidth', 2);

    plot([mid_point2(1), end_pos(1)], [mid_point2(2), end_pos(2)], 'b', 'LineWidth', 2);
end

% 绘制路径交叉点的红点
intersection_points = [
    0, 1.25;        % 原始交点
    -1.25, 3.75;    % 原始交点
     % 原始交点
       % 原始交点
    0, -1.25;       % 中心对称点
    1.25, -3.75;    % 中心对称点

    % 轴对称点
    0, -1.25;       % 关于x轴对称
    1.25, 3.75;     % 关于y轴对称

    0, -1.25;       % 关于原点对称
    -1.25, -3.75;   % 关于原点对称
    3.75,1.25;
    3.75,-1.25;
    -3.75,-1.25;
    -3.75,1.25;
    1.25,0;
    -1.25,0;

    3.75,3.75;
    3.75,-3.75;
    -3.75,-3.75;
    -3.75,3.75;

    3.75,5;
    3.75,-5;
    -3.75,-5;
    -3.75,5;
    5,3.75;
    5,-3.75;
    -5,-3.75;
    -5,3.75;
];

plot(intersection_points(:,1), intersection_points(:,2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% 设置图形属性
xlabel('X Position (m)');
ylabel('Y Position (m)');
xlim([-20 20]);
ylim([-20 20]);
title('intersection paths');
grid on;

hold off;
