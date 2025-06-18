function exponent_arrays = exponent_arranger(p, K)
% This is a function that generates all possible arrays for the
% exponent vector beta.
% K: maximum memory depth (where each memory basis will be assigned an
% exponent).
% p: L1 norm of the polynomial order (sum of the exponents).
% exponent_arrays: the output matrix, where each row represents a
% possible arrangement of exponents for the exponent vector beta.

if K == 0
    % If there's only one place left, it must be the sum P
    exponent_arrays = p;
    return;
end

exponent_arrays = [];
for i = 0:p
    % Recursively generate the rest of the beta array arrangements
    sub_arrangements = exponent_arranger(p-i, K-1);
    % Prepend the current number i to each of the sub_arrangements
    exponent_arrays = [exponent_arrays; [repmat(i, size(sub_arrangements, 1), 1), sub_arrangements]];
end
end