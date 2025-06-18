function MEM_measure_order = MEM_measure_porder_compute(Coeff_array,k,Exponent_matrix)
% This function computes the kth-order memory measure for a specific 
% system response, with its estimated coefficients.
% Coeff_array: the estimated Volterra kernel coefficients for the specific
% response.
% k: the depth of memory
% Exponent_matrix: the matrix of exponents used as reference for computing
% the measure.

MEM_measure_order = 0;

% sum all coefficients associated with a non-zero exponent for the kth 
% memory step.
for i = 1:length(Exponent_matrix)
    if Exponent_matrix(i,k+1) ~= 0
        MEM_measure_order = MEM_measure_order +abs(Coeff_array(i));
    end
end

end