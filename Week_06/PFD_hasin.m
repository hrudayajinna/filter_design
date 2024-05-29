% Call the pfd function and capture the output values
[A_out, B_out] = PFD(100, 100);

% Display the output values
disp(['Qa: ' num2str(A_out)]);
disp(['Qb: ' num2str(B_out)]);
