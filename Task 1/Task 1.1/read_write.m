global A = csvread('csv_matter.csv');  #do not change this line

################################################
#######Declare your global variables here#######
global ax_f=0;
global ay_f=0;
global az_f=0;
global gx_f=0;
global gy_f=0;
global gz_f=0;
global gx_l=0;
global gy_l=0;
global gz_l=0;
global angle_p=0;
global angle_r=0;
global B;
################################################


function read_accel(axl,axh,ayl,ayh,azl,azh)  
  
  #################################################
  ####### Write a code here to combine the ########
  #### HIGH and LOW values from ACCELEROMETER #####
  ax=bitor(bitshift(axh,8),axl);
  ay=bitor(bitshift(ayh,8),ayl);
  az=bitor(bitshift(azh,8),azl);
  f_cut=5;
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
  #################################################


  ####################################################
  # Call function lowpassfilter(ax,ay,az,f_cut) here #
  lowpassfilter(ax,ay,az,f_cut)
  ####################################################

endfunction

function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
  #################################################
  ####### Write a code here to combine the ########
  ###### HIGH and LOW values from GYROSCOPE #######
  gx=bitor(bitshift(gxh,8),gxl);
  gy=bitor(bitshift(gyh,8),gyl);
  gz=bitor(bitshift(gzh,8),gzl);
  f_cut=5;
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
  #################################################


  #####################################################
  # Call function highpassfilter(ax,ay,az,f_cut) here #
  highpassfilter(gx,gy,gz,f_cut);
  #####################################################;

endfunction



function lowpassfilter(ax,ay,az,f_cut)
  dT = 1/100;  #time in seconds
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);                #do not change this line
  
  ################################################
  ##############Write your code here##############
  global ax_f;
  global ay_f;
  global az_f;
  ax_f=(1-alpha)*ax+alpha*ax_f;
  ay_f=(1-alpha)*ay+alpha*ay_f;
  az_f=(1-alpha)*az+alpha*az_f; 
  ################################################
  
endfunction



function highpassfilter(gx,gy,gz,f_cut)
  dT = 1/100;  #time in seconds
  Tau= 1/(2*pi*f_cut);
  alpha = Tau/(Tau+dT);                #do not change this line
  
  ################################################
  ##############Write your code here##############
  global gx_f;
  global gy_f;
  global gz_f;
  global gx_l;
  global gy_l;
  global gz_l;
  gx_f= (1-alpha)*gx_f + (1-alpha)*(gx-gx_l);
  gy_f= (1-alpha)*gy_f + (1-alpha)*(gy-gy_l);
  gz_f= (1-alpha)*gz_f + (1-alpha)*(gz-gz_l);
  gx_l = gx;
  gy_l = gy; 
  gz_l = gz;
  ################################################
  
endfunction

function comp_filter_pitch(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate  ######
  ####### PITCH using complementry filter ######
  global ax_f;
  global ay_f;
  global az_f;
  global gx_f;
  global gy_f;
  global gz_f;
  global angle_p;
  alpha = 0.03;
  dt = 1/100;
  acc_p=atan(ay_f/abs(az_f))*180/pi;
  angle_p=(1-alpha)*(angle_p+-1*gx_f*dt)+(alpha)*(acc_p);
  ##############################################

endfunction 

function comp_filter_roll(ax,ay,az,gx,gy,gz)

  ##############################################
  ####### Write a code here to calculate #######
  ####### ROLL using complementry filter #######
  global ax_f;
  global ay_f;
  global az_f;
  global gx_f;
  global gy_f;
  global gz_f;
  global angle_r;  
  alpha = 0.03;
  dt = 1/100;
  acc_r=atan(ax_f/abs(az_f))*180/pi; 
  angle_r=(1-alpha)*(angle_r+-1*gy_f*dt)+(alpha)*(acc_r); 
  ##############################################

endfunction 

function execute_code
  global A;
  global B;
  for n = 1:rows(A)                    #do not change this line
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    global ax_f;
    global ay_f;
    global az_f;
    global gx_f;
    global gy_f;
    global gz_f;
    global gx_l;
    global gy_l;
    global gz_l;
    global angle_p;
    global angle_r;
    axh=A(n,1);
    axl=A(n,2);
    ayh=A(n,3);
    ayl=A(n,4);
    azh=A(n,5);
    azl=A(n,6);
    read_accel(axl,axh,ayl,ayh,azl,azh)
    gxh=A(n,7);
    gxl=A(n,8);
    gyh=A(n,9);
    gyl=A(n,10);
    gzh=A(n,11);
    gzl=A(n,12);
    read_gyro(gxl,gxh,gyl,gyh,gzl,gzh);
    comp_filter_pitch(ax_f,ay_f,az_f,gx_f,gy_f,gz_f);
    comp_filter_roll(ax_f,ay_f,az_f,gx_f,gy_f,gz_f);
    B(n,1)=angle_p;
    B(n,2)=angle_r;
    
    ###############################################
    
  endfor
  csvwrite('output_data.csv',B);        #do not change this line
endfunction


execute_code                           #do not change this line
