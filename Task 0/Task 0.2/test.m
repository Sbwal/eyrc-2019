pkg load symbolic      # Load the octave symbolic library
syms x1 x2             # Define symbolic variables x1 and x1
 x1_dot = x2;
 m1 = 7.5;
  m2 = 7.51;
  g = 9.8;
  r = 0.2;
  u=0;
  x2_dot = g*(m1-m2)/(m1+m2)+u/(r*(m1+m2)); 
#x1_dot = x2 ;       # Write the expressions for x1_dot and x2_dot
#x2_dot = 1;    # YOU CAN MODIFY THESE 2 LINES TO TEST OUT OTHER EQUATIONS

#[equilibrium_points jacobians eigen_values stability] = main_function(x1_dot, x2_dot);

eqbm_points = solve(x1_dot==0,x2_dot==0)
 
  syms x1 x2
  solutions = {};
  jacobian_matrices = {};
  for k = 1:length(eqbm_points)
    x_1 = eqbm_points{k}.x1;
    x_2 = eqbm_points{k}.x2;
    soln = [x_1 x_2];
    solutions{k} = soln;
  endfor
  
  for k = 1:length(solutions)
   j_m{k}=subs(jacobian([x1_dot,x2_dot],[x1,x2]),{x1 x2},solutions{k});
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
    eigen_values{k}=eig(matrix);
    
    if real(eigen_values{k})>0
      flag = 0;
    else 
      flag = 1;
    endif   
    if flag == 1
      fprintf("The system is stable for equilibrium point (%d, %d) \n",double(eqbm_points{k}.x1),double(eqbm_points{k}.x2));
      stability{k} = "Stable";
    else
      fprintf("The system is unstable for equilibrium point (%d, %d) \n",double(eqbm_points{k}.x1),double(eqbm_points{k}.x2)); 
      stability{k} = "Unstable";
    endif
  endfor
  