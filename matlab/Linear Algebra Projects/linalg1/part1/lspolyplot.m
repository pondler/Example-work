function [ ] = lspolyplot()
load('tycho.mat')

%assign degree vector
deg = [5,10,20];
%create matrix with three rows of the LS plots
plot_vec = [lspoly(5); lspoly(10); lspoly(20)];
plot_vec = reshape(plot_vec,size(lspoly(5),1),3);

% plot them and save as jpgs
for i = 1:3
    figure()
    hold on
    plot(x, h, 'color', [0 0 0.4], 'linewidth',0.75)
    plot(x, plot_vec(:,i), 'color', [1 0 0])
    hold off

    xlabel('x - sample points')
    ylabel('h - crater height')
    title(['plot of actual height and least squares polynomial of degree ' num2str(deg(i))])
    print(['plot_of_x_against_height_&_lsp_deg_' num2str(deg(i))],'-dpng');

end
