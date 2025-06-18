function exponent_array_constrain = exponent_arranger_with_constraint(p, K, L)
% This is a function that generates all possible arrays for the
% exponent vector beta, with a constraint of maximum non-zero
% exponents L. For example, L=1 means a homogeneous polynomial with no
% memory cross terms.
% K: maximum memory depth (where each memory basis will be assigned an
% exponent).
% p: L1 norm of the polynomial order (sum of the exponents).
% L: maximum number of non-zero exponents required in each possible
% array arrangement.
% exponent_arrays_constrain: the output matrix, where each row represents
% a possible arrangement of exponents for the exponent vector beta,
% under the constraint of maximum non-zero exponents L.

L_min = K+1-L; % calculate minimum number of zeros required.

% generate all arrangements that gives an order p.
exponent_arrays = exponent_arranger(p, K);

% gount the number of zeros in each row
zero_counts = sum(exponent_arrays == 0, 2);

% Keep only rows with at least L_min zeros
exponent_array_constrain = exponent_arrays(zero_counts >= L_min, :);
end

