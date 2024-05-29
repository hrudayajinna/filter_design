% Define the reference and divided signals
refSignal = [0 1 1 0 1 1 0 1];  % Example reference signal (can be replaced with your actual signal)
divSignal = [0 0 1 1 1 0 0 1];  % Example divided signal (can be replaced with your actual signal)

% Initialize the J-K flip-flop inputs
J = [];
K = [];

% Initialize the flip-flop outputs
Q = [];
Q_bar = [];

% Initialize the phase difference between reference and divided signals
phaseDifference = [];

% Perform phase detection and calculate Q, Q_bar, and phase difference
for i = 1:length(refSignal)
    % Determine the J-K inputs based on the phase difference
    if refSignal(i) == 0 && divSignal(i) == 0
        J(i) = 0;
        K(i) = 0;
    elseif refSignal(i) == 0 && divSignal(i) == 1
        J(i) = 0;
        K(i) = 1;
    elseif refSignal(i) == 1 && divSignal(i) == 0
        J(i) = 1;
        K(i) = 0;
    elseif refSignal(i) == 1 && divSignal(i) == 1
        J(i) = 1;
        K(i) = 1;
    end
    
    % Calculate Q and Q_bar based on J-K inputs
    if i == 1
        Q(i) = 0;  % Initial value of Q
        Q_bar(i) = 1;  % Initial value of Q_bar
    else
        % Update Q and Q_bar based on J-K inputs and previous values
        if J(i) == 0 && K(i) == 0
            Q(i) = Q(i-1);
            Q_bar(i) = Q_bar(i-1);
        elseif J(i) == 0 && K(i) == 1
            Q(i) = 0;
            Q_bar(i) = 1;
        elseif J(i) == 1 && K(i) == 0
            Q(i) = 1;
            Q_bar(i) = 0;
        elseif J(i) == 1 && K(i) == 1
            Q(i) = ~Q(i-1);  % Toggle the previous value of Q
            Q_bar(i) = ~Q_bar(i-1);  % Toggle the previous value of Q_bar
        end
    end
    
    % Calculate the phase difference
    phaseDifference(i) = Q(i) - Q_bar(i);
end

% Display the J-K inputs, Q, Q_bar, and phase difference
disp('J-K Flip-Flop Inputs:');
disp('J: ');
disp(J);
disp('K: ');
disp(K);

disp('Q:');
disp(Q);
disp('Q_bar:');
disp(Q_bar);

disp('Phase Difference:');
disp(phaseDifference);

% Calculate the KPD (phase difference gain)
KPD = sum(phaseDifference) / length(phaseDifference);
disp('KPD:');
disp(KPD);
