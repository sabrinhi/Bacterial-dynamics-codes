close all
clear all
clc
%%  
global g d

for i = 1:11
    [num{i},txt{i},raw{i}] = xlsread('Supplementary file1.xlsx',i);
end

[status,sheets] = xlsfinfo('Supplementary file1.xlsx')

% Initial conditions
start = {[10^-6,900,9.5*10^-4;10^-6,800,10^-3;10^-6,626,10^-3;10^-6,600,10^-3];...
[10^-6,500,10^-3;10^-7,500,10^-3;10^-6,400,10^-3;10^-6,500,1.75*10^-3];...
[10^-7,900,1.8*10^-3;1.5*10^-6,780,9.5*10^-4;10^-6,690,8*10^-4;10^-6,670,10^-3;10^-6,675,10^-3];...
[5*10^-7,280,10^-3;10^-6,660,10^-3;10^-6,570,10^-3;10^-6,450,10^-3;10^-6,500,10^-3];...
[10^-6,510,10^-3;2*10^-6,659,2*10^-3;8*10^-7,505,10^-3;10^-6,650,2*10^-3];...
[10^-6,500,10^-3;8*10^-7,830,10^-3;10^-6,900,10^-3;3*10^-6,550,10^-3];...
[10^-6,134,5*10^-3;10^-6,400,10^-3;10^-6,200,10^-3;6*10^-6,150,5*10^-3;10^-6,500,10^-3;2*10^-6,200,10^-3;10^-6,500,10^-3];...
[10^-6,500,10^-3;4*10^-7,700,10^-3;10^-6,200,2*10^-3;5*10^-7,500,10^-3;10^-6,505,10^-3;5*10^-6,600,3*10^-4];...
[10^-6,450,10^-3;2.3*10^-6,405,10^-3;10^-6,410,2*10^-3;10^-6,500,10^-3;5*10^-6,500,10^-3];...
[10^-6,372,10^-3;10^-6,535,10^-3;10^-6,500,10^-3;2.5*10^-6,640,10^-3;10^-6,735,10^-3;10^-6,430,10^-3;1.5*10^-6,492,10^-3];...
[10^-6,580,1.8*10^-3;10^-6,500,10^-3;10^-6,620,10^-3;10^-6,500,10^-3;10^-6,480,10^-3]};

growth = [1.245,1.074,1.348,1.457,1.431,1.486,1.445,1.433,1.433,1.469,1.415];
death = [0.049,0.043,0.048,0.093,0.065,0.035,0.029,0.041,0.090,0.052,0.030];
data_max = [4919.219, 2586.127, 4491.558, 3045.551, 3474.521, 5786.075, 1740.926 2815.168, 4042.593, 3243.328, 3986.045];

rhos = zeros(10,11);
p_values = zeros(10,11);

time_vec = num{1}(1,:);

for i = 1:11
   cfu_data = num{i}(2:end,:);
   first = repmat(cfu_data(:,1),1,11);
   cfu_data =  cfu_data ./ first;
   [row,col] = size(cfu_data);
   parameters = zeros(row,9);
   g = growth(i);
   d = death(i);

   for j = 1:row
      sample = cfu_data(j,:);
      fixed_merged = sample(~isnan(sample));
      t_fixed = time_vec(~isnan(sample));
      
      % Fit!
      fo = fitoptions('Method','NonlinearLeastSquares',...
      'Lower',[0,100,0],...
      'Upper',[10^-5,inf,inf],...
      'StartPoint',start{i}(j,:));
      ft = fittype('QSinR2(x,k1,k2,u)','options',fo);
      s = fit(t_fixed',fixed_merged',ft);
      figure(i)
      subplot(ceil(row./2),2,j)
      hold on
      plot(t_fixed,fixed_merged,'o');
      legend('off')
      plot(s);
      title(strcat(sheets{i},'-Sample',num2str(j)));
      legend('off')
      
      k1 = s.k1
      k2 = s.k2
      b = s.u 

    [rho,pvalue] = corr(s(t_fixed),fixed_merged');
    
    rhos(j,i) = rho;
    p_values(j,i) = pvalue;
      
   end

end
