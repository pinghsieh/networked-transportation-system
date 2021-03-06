function createfigure_test(X1, YMatrix1)
%CREATEFIGURE1(X1, YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 11-Jan-2017 15:18:42

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'MarkerSize',10,'LineWidth',2.5);
set(plot1(1),'DisplayName','Movement 1','Marker','s','Color',[0 0 1]);
set(plot1(2),'DisplayName','Movement 2','Marker','x','Color',[1 0 0]);

% Create xlabel
xlabel({'Time (slot)'});

% Create ylabel
ylabel({'Queue Length'});

box(axes1,'on');
grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',18,'LineWidth',2.5);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.167261909498345 0.752777781751422 0.29107142207878 0.144047615073976]);

