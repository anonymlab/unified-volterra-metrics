function NL_measure_order = NL_measure_porder_compute(Coeff_array,p,Exponent_matrix)
% This function computes the pth-order nonlinearity measure for a specific 
% system response, with its estimated coefficients.
% Coeff_array: the estimated Volterra kernel coefficients for the specific
% response.
% p: the order of nonlinearity
% Exponent_matrix: the matrix of exponents used as reference for computing
% the measure.

NL_measure_order = 0;

% sum all coefficients associated with a nonlinearity order p.
for i = 1:length(Exponent_matrix)
    if sum(Exponent_matrix(i,:)) == p
        NL_measure_order = NL_measure_order +abs(Coeff_array(i));
    end
end

end