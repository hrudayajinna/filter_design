% The received and clock signals
receivedSignal = [1 0 1 0 1 0];  % Example received signal (replace with your actual signal)
clockSignal = [0 1 0 1 0 1];  % Example clock signal (replace with your actual signal)

% Initialize the J-K flip-flop inputs
J = zeros(1, length(receivedSignal));
K = zeros(1, length(receivedSignal));

% Initialize the flip-flop outputs
Q_lead = zeros(1, length(receivedSignal));
Q_lag = zeros(1, length(receivedSignal));

% Perform phase detection and calculate J-K inputs
for i = 1:length(receivedSignal)
    % Determine the J-K inputs based on the phase difference
    if receivedSignal(i) == 0 && clockSignal(i) == 1
        K(i) = 1;
    elseif receivedSignal(i) == 1 && clockSignal(i) == 0
        J(i) = 1;
    elseif receivedSignal(i) == 1 && clockSignal(i) == 1
        J(i) = 1;
        K(i) = 1;
    end
end

% Initialize the initial values of Q_lead and Q_lag
Q_lead(1) = 1;  % Initial value of Q_lead
Q_lag(1) = 1;  % Initial value of Q_lag

% Update Q_lead and Q_lag based on J-K inputs
for i = 2:length(J)
    if J(i) == 0 && K(i) == 0
        Q_lead(i) = Q_lead(i-1);
        Q_lag(i) = Q_lag(i-1);
    elseif J(i) == 0 && K(i) == 1
        Q_lead(i) = Q_lead(i-1) & ~Q_lag(i-1);  % AND operation with negation
        Q_lag(i) = ~Q_lag(i-1);  % Toggle the previous value of Q_lag
    elseif J(i) == 1 && K(i) == 0
        Q_lead(i) = ~Q_lead(i-1);  % Toggle the previous value of Q_lead
        Q_lag(i) = Q_lag(i-1) & ~Q_lead(i-1);  % AND operation with negation
    elseif J(i) == 1 && K(i) == 1
        Q_lead(i) = Q_lead(i-1);
        Q_lag(i) = Q_lag(i-1);
    end
end

disp('Leading signal:');
disp(Q_lead);
disp('Lagging signal:');
disp(Q_lag);

% Define the digital filters for leading and lagging sides
leadingFilter = [1 -1];  
laggingFilter = [1 1];  

% Apply the digital filters to the Q_lead and Q_lag signals
filteredLeading = filter(leadingFilter, 1, Q_lead);
filteredLagging = filter(laggingFilter, 1, Q_lag);

disp('Filtered leading signal:');
disp(filteredLeading);
disp('Filtered lagging signal:');
disp(filteredLagging);

% Calculate the phase difference
phaseDifference = Q_lead - Q_lag;

% Subtract the filter outputs from the phase difference
phaseDifference = phaseDifference - (filteredLeading + filteredLagging);


% Display the phase difference
disp('Phase Difference:');
disp(phaseDifference);
