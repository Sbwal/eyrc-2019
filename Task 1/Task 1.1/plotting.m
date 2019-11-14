E = csvread('csv_output.csv');
D = csvread('output_data.csv');
x=[];
c=[];
y=2;
for n=1:1000
  x(n)=n;
  c(n)=D(n,y); 
endfor
plot(x,E(:,y),x,c)