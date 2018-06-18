

load tycho 

sample_size = [500 100 25 20];

for i = 1:4
    figure()
    hold on
    
    plot(x, h)
    plot(x, reduced_MLSpoly(sample_size(i)))
    plot(x, reduced_MLSpoly( 1001) ) 
    
    hold off

    xlabel('x - sample points')
    ylabel('h - crater height')
    title(['plot of actual height and reduced MLS of sample size ' num2str(sample_size(i))])
    print(['plot_of_x_against_height_and_red_MLS' num2str(sample_size(i))],'-dpng');
end