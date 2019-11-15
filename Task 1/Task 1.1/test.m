 X = csvread('csv_matter.csv');  
 Y=[,];
ax_f=0;
ay_f=0;
az_f=0;
gx_f=0;
gy_f=0;
gz_f=0;
gx_l=0;
gy_l=0;
gz_l=0;
a_p=0;
a_r=0;
angle_p=0;
angle_r=0;
num=10;
for n = 1:num#rows(A)                        
n
w=X(n,:);
axh=w(1);
axl=w(2);
ayh=w(3);
ayl=w(4);
azh=w(5);
azl=w(6);
ax=bitor(bitshift(axh,8),axl);
ay=bitor(bitshift(ayh,8),ayl);
az=bitor(bitshift(azh,8),azl);
if ax>32767
    ax=ax-65536;
  endif  
  if ay>32767
    ay=ay-65536;
  endif
  if az>32767
    az=az-65536;
  endif  
  ax=ax/16384;
  ay=ay/16384;
  az=az/16384;
gxh=w(7);
gxl=w(8);
gyh=w(9);
gyl=w(10);
gzh=w(11);
gzl=w(12);
gx=bitor(bitshift(gxh,8),gxl);
gy=bitor(bitshift(gyh,8),gyl);
gz=bitor(bitshift(gzh,8),gzl);
 if gx>32767
    gx=gx-65536;
  endif  
  if gy>32767
    gy=gy-65536;
  endif
  if gz>32767
    gz=gz-65536;
  endif
  gx=gx/131;
  gy=gy/131;
  gz=gz/131;
f_cut=5;
dt = 1/100;  #time in seconds
Tau= 1/(2*pi*f_cut);
alpha = Tau/(Tau+dt);

ax_f=(1-alpha)*ax+alpha*ax_f;
ay_f=(1-alpha)*ay+alpha*ay_f;
az_f=(1-alpha)*az+alpha*az_f;
gx_f= (1-alpha)*gx_f + (1-alpha)*(gx-gx_l);
gy_f= (1-alpha)*gy_f + (1-alpha)*(gy-gy_l);
gz_f= (1-alpha)*gz_f + (1-alpha)*(gz-gz_l);
gx_l = gx;
gy_l = gy; 
gz_l = gz;

 alpha = 0.03;
  dt = 1/100;
  gc_p=gx_f;
  ac_p=atan2(ay_f,abs(az_f))*180/pi;
  
  a_p=(1-alpha)*(a_p+-1*gc_p*dt)+(alpha)*(ac_p);
  
  gc_r=gy_f;
  ac_r=atan2(ax_f,abs(az_f))*180/pi;
  a_r=(1-alpha)*(a_r+-1*gc_r*dt)+(alpha)*(ac_r);
Y(n,1)=num2str(a_p);

endfor

G = csvread('csv_output.csv');
x=[1:num];
plot(x,G(1:num,1),x,Y(:,1))
