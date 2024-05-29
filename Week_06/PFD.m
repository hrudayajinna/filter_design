function [Qa, Qb] = PFD(A, B)
    persistent Qa_state Qb_state;
    if isempty(Qa_state) || isempty(Qb_state)
        Qa_state = 0;
        Qb_state = 0;
    end
    
    if A < B
        Qa_state = 1;
        Qb_state = 0;
    elseif A == B
        Qa_state = 0;
        Qb_state = 0;
    elseif A > B
        Qa_state = 0;
        Qb_state = 1;
    end
    
    Qa = Qa_state;
    Qb = Qb_state;
end

