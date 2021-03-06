function createfigure_bar(ymatrix1)
%CREATEFIGURE1(YMATRIX1)
%  YMATRIX1:  bar matrix data

%  Auto-generated by MATLAB on 14-Dec-2015 22:38:58

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'LineWidth',6,...
    'XTickLabel',{'0', '0.01', '0.03', '0.05','0.1','0.15','0.2','0.3','0.4','0.45'},...
    'XTick',[1 2 3 4 5 6 7 8 9 10],...
    'FontWeight','bold',...
    'FontSize',24);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'on');

% Create multiple lines using matrix input to bar
bar1 = bar(ymatrix1,'Parent',axes1);
set(bar1(1),'DisplayName','Queue 1');
set(bar1(2),'DisplayName','Queue 2');
set(bar1(3),'DisplayName','Queue 3');
set(bar1(4),'DisplayName','Queue 4');
set(bar1(5),'DisplayName','Queue 5');
set(bar1(6),'DisplayName','Queue 6');
set(bar1(7),'DisplayName','Queue 7');
set(bar1(8),'DisplayName','Queue 8');

% Create ylabel
ylabel({'Per-Flow Average Delay'},'FontSize',30.8);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.854311678347545 0.17977210093937 0.107888629811269 0.782905960083008]);

