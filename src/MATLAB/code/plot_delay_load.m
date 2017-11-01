function plot_delay_load
    slot = 2.5;
    str = {'Fixed-time', 'Max-Weight', 'Proposed'};
    style = {'kx-', 'bo-', 'm^-', 'rd-'};
    f1 = sprintf('delay_Fixed_Time.dat');
    delay1 = load(f1);
    %semilogy(delay1(:,1), slot*delay1(:,2), style{1}, 'Linewidth', 3, 'MarkerSize', 10);
    plot(delay1(:,1), slot*delay1(:,2), style{1}, 'Linewidth', 3, 'MarkerSize', 10);
    hold on; grid on;
    set(gcf, 'color', [1 1 1]);
    xlabel('Traffic load');
    ylabel('Average delay (Sec)');
 
    f2 = sprintf('delay_MaxWeight_Adhoc_lim.dat');
    delay2 = load(f2);
    %semilogy(delay2(:,1), slot*delay2(:,2), style{2}, 'Linewidth', 3, 'MarkerSize', 10);
    plot(delay2(:,1), slot*delay2(:,2), style{2}, 'Linewidth', 3, 'MarkerSize', 10);   
    
    f3 = sprintf('delay_VFMW_adhoc_diff_lim.dat');
    delay3 = load(f3);
    %semilogy(delay3(:,1), slot*delay3(:,2), style{3}, 'Linewidth', 3, 'MarkerSize', 10);  
    plot(delay3(:,1), slot*delay3(:,2), style{3}, 'Linewidth', 3, 'MarkerSize', 10);  
    
    fig = gcf();
    set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);  
    legend(str, 'location', 'northwest');
    print('-depsc2', sprintf('delay_load.eps'));

end