% script to plot MLS polynomials as degree and eta varies

load('tycho.mat')

deg = [1,3,10];
eta = [1e-2,1e-3,1e-4];

% loop through degree values
for i = 1:3
    figure()
    hold on
    plot(x, h, 'color', [0 0 0.4], 'linewidth',0.75)
    plot(x, MLSpoly(deg(i),eta(1),1e-6), 'color', [1 0 0])
    hold off

    xlabel('x - sample points')
    ylabel('h - crater height')
    title(['plot of actual height and MLS polynomial of degree ' num2str(deg(i)) ', eta = 10^-3'])
    print(['plot_of_x_against_height_and_MLS_degree' num2str(deg(i)) 'eta=10^-3'],'-dpng');
end

% loop through eta values
for i = 1:3
    figure()
    hold on
    plot(x, h, 'color', [0 0 0.4], 'linewidth',0.75)
    plot(x, MLSpoly(deg(2),eta(i),1e-6), 'color', [1 0 0])
    hold off

    xlabel('x - sample points')
    ylabel('h - crater height')
    title(['plot of actual height and MLS polynomial of degree 3, eta = 10^-' num2str(i+1)])
    print(['plot_of_x_against_height_and_MLS_polynomial_of_degree_3_eta=10^-' num2str(i+1)],'-dpng');
end
