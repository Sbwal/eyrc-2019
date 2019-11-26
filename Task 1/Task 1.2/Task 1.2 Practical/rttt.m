pkg load symbolic      # Load the octave symbolic library
syms x1 x2 y1 y2 L M m g u
  
  
  x1_d = x2;
  x2_d = (y2*y2*sin(y1)+g*m*sin(y1)*cos(y1))/(M+m*sin(y1)*sin(y1))+u/(M+m*sin(y1)*sin(y1));
  y1_d = y2;
  y2_d = (g*sin(y1)-((y2*y2*sin(y1)+g*m*sin(y1)*cos(y1))/(M+m*sin(y1)*sin(y1))+u/(M+m*sin(y1)*sin(y1)))*cos(y1))/L;  
  eqbm_points = solve(x1_d==0,x2_d==0,y1_d==0,y2_d==0)
  solutions = {};
  jacobian_matrices = {};
  subs(jacobian([x1_d,x2_d,y1_d,y2_d],[x1,x2,y1,y2]),{x1 x2 y1 y2},[0,0,pi,0])
  subs(jacobian([x1_d,x2_d,y1_d,y2_d],[u]),{x1 x2 y1 y2},[0,0,pi,0])
 #{
 subs(jacobian([x1_d,x2_d,y1_d,y2_d],[x1,x2,y1,y2]),{x1 x2 y1 y2},[0,0])
 for k = 1:length(eqbm_points)
   # x_1 = eqbm_points{k}.x1;    
    x_2 = eqbm_points{k}.x2;
    y_1 = eqbm_points{k}.y1;
    y_2 = eqbm_points{k}.y2;
    soln = [0 x_2 y_1 y_2];
    solutions{k} = soln;
  endfor
  
 for k = 1:length(solutions)
    jacobian([x1_d,x2_d,y1_d,y2_d],[x1,x2,y1,y2])
    subs(jacobian([x1_d,x2_d,y1_d,y2_d],[x1,x2,y1,y2]),{x1 x2 y1 y2},solutions{k})
   j_m{k}=subs(jacobian([x1_d,x2_d,y1_d,y2_d],[x1,x2,y1,y2]),{x1 x2 y1 y2},solutions{k})
   jacobian_matrices{k}=double(j_m{k});
  endfor
  

  disp(jacobian_matrices);
  
  stability = {};
  eigen_values = {};  
  #jacobian_matrices={[5 1;-1 -1],[-1 1;-1 -1],[5 1;-1 -1]}
  for k = 1:length(jacobian_matrices)
    matrix = jacobian_matrices{k};
    #disp(matrix);
    flag = 0;
    eigen_values{k}=eig(matrix)
    
    if real(eigen_values{k})>0
      flag = 0;
    else 
      flag = 1;
    endif
    if flag == 1
      fprintf("The system is stable for equilibrium point (%d, %d) \n",double(eqbm_points{k}.x2),double(eqbm_points{k}.y1),double(eqbm_points{k}.y2));
      stability{k} = "Stable";
    else
      fprintf("The system is unstable for equilibrium point (%d, %d) \n",double(eqbm_points{k}.x2),double(eqbm_points{k}.y1),double(eqbm_points{k}.y2)); 
      stability{k} = "Unstable";
    endif
  endfor
  }#