function [Qa, Qb] = pfd_dflip(A, B)
    persistent Qa_state Qb_state prev_A prev_B;
    if isempty(Qa_state) || isempty(Qb_state) || isempty(prev_A) || isempty(prev_B)
        Qa_state = 0;
        Qb_state = 0;
        prev_A = 0;
        prev_B = 0;
    end
    
    Qa = Qa_state;
    Qb = Qb_state;
    
    D_input = 1; % D input of the flip-flops connected to logical one
    
    if A > prev_A && B > prev_B
        Qa_state = 1;
        Qb_state = 0;
    elseif A == prev_A && B > prev_B
        Qa_state = 0;
        Qb_state = 1;
    elseif A > prev_A && B == prev_B
        Qa_state = 1;
        Qb_state = 0;
    else
        Qa_state = 0;
        Qb_state = 0;
    end
    
    prev_A = A;
    prev_B = B;
end
