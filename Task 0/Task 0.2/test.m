pkg load symbolic      # Load the octave symbolic library
syms x1 x2             # Define symbolic variables x1 and x1

x1_dot = -x1 + 2*x1^3 + x2;       # Write the expressions for x1_dot and x2_dot
x2_dot = -x1 - x2;   # YOU CAN MODIFY THESE 2 LINES TO TEST OUT OTHER EQUATIONS

#[equilibrium_points jacobians eigen_values stability] = main_function(x1_dot, x2_dot);
x1_dot==0;
x2_dot==0;
eqbm_points = solve(x1_dot,x2_dot);
  #disp(eqbm_points);
  syms x1 x2
  solutions = {};
  jacobian_matrices = {};
  for k = 1:length(eqbm_points)
    x_1 = eqbm_points{k}.x1;
    x_2 = eqbm_points{k}.x2;
    soln = [x_1 x_2];
    solutions{k} = soln;
  endfor
  #disp(x1_dot);
  #disp(x2_dot);
  jacobian_m=jacobian([x1_dot;x2_dot],[x1;x2]);
  #disp(jacobian_m);
  #jm=[[6*x1^2-1 1];[-1 -1]];
  #disp(length(eqbm_points))
  for k = 1:length(solutions)
   jacobian_matrices{k}=subs(jacobian_m,{x1 x2},solutions{k});
   #celldisp({subs(jacobian_m,{x1 x2},solutions{k})});
  endfor
  #celldisp(jacobian_matrices)
  stability = {};
  eigen_values = {};
  k=2;
  for k = 1:length(jacobian_matrices)
    matrix = jacobian_matrices{k};
    disp(matrix);
    flag = 0;
    eigen_values{k}=eig(matrix)
    #disp(eig(matrix));
    if real(eigen_values{k})<0
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