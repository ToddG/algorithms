------------------------------ MODULE vector_clock1  ------------------------------
EXTENDS TLC
PT == INSTANCE PT
LOCAL INSTANCE FiniteSets
LOCAL INSTANCE Integers
LOCAL INSTANCE Sequences
LOCAL INSTANCE Naturals

\* ---------------------------------------------------------------------------
\* Constants
\* ---------------------------------------------------------------------------
CONSTANT Procs                  \* Processors (set)
CONSTANT MaxClockValue          \* Max value for any process's clock
CONSTANT MaxInboxLength         \* Limit the size of the inbox

\* ---------------------------------------------------------------------------
\* Assumptions
\* ---------------------------------------------------------------------------
ASSUME Cardinality(Procs)   > 0     \* Need at least one proc
ASSUME MaxClockValue        > 0     \* Need something to increment to
ASSUME MaxInboxLength       > 0     \* Need an inbox to append to

\* ---------------------------------------------------------------------------
\* Variables
\* ---------------------------------------------------------------------------
VARIABLES 
    \* Each process maintains an array of clock values: v[1..N][1..N]
    v
    \* Each process has an inbox to receieve from. The inbox is written
    \* to by a 'send' action, and is read from by a 'read' action:
    \* inbox[1..N][[1..N]]
    ,inbox
    \* Global program counter record, for displaying Action in graphs and 
    \* debugging. Only useful for small values of MaxClockValue and 
    \* MaxInboxLength.
    ,edge

vars  == << v, inbox, edge >>

\* ---------------------------------------------------------------------------
\* Constraints
\* ---------------------------------------------------------------------------
TypeOK ==
    /\ MaxClockValue \in Nat
    /\ \A i,j \in Procs : v[i][j] \in Nat

ClockValueConstraint ==
    \A i,j \in Procs : v[i][j] <= MaxClockValue

InboxLengthConstraint ==
    \A i \in Procs : Len(inbox[i]) <= MaxInboxLength

Constraints ==
    /\ TypeOK
    /\ ClockValueConstraint
\*    /\ InboxLengthConstraint

\* ---------------------------------------------------------------------------
\* ActionConstraints
\* ---------------------------------------------------------------------------
ClocksNeverDecrease ==
    \A i,j \in Procs : v'[i][j] >= v[i][j]

ActionConstraints ==
    /\ ClocksNeverDecrease

\* ---------------------------------------------------------------------------
\* Invariants
\* ---------------------------------------------------------------------------
Invariants == TRUE \* TODO

\* ---------------------------------------------------------------------------
\* Helpers
\* ---------------------------------------------------------------------------

VMax(x, y) ==
    [k \in DOMAIN x |-> PT!Max(x[k], y[k])]

TestVMax0 ==
    LET
        v1 == [k \in Procs |-> 0]
        v2 == [k \in Procs |-> 1]
        v3 == [k \in Procs |-> 1]
    IN
        /\ VMax(v1, v2) = v3

TestVMax1 ==
    LET
        v1 == [a |-> 0]
        v2 == [a |-> 1]
        v3 == [a |-> 1]
    IN
        /\ VMax(v1, v2) = v3

TestVMax2 ==
    LET
        v1 == [a |-> 0, b |-> 1]
        v2 == [a |-> 1, b |-> 0]
        v3 == [a |-> 1, b |-> 1]
    IN
        /\ VMax(v1, v2) = v3

TestVMax3 ==
    LET
        v1 == [a |-> 0, b |-> 1, c |-> 99]
        v2 == [a |-> 1, b |-> 0, c |-> 0]
        v3 == [a |-> 1, b |-> 1, c |-> 99]
    IN
        /\ VMax(v1, v2) = v3


TestReduceVMax1 ==
    LET
        v1 == [a |-> 0]
        v2 == [a |-> 1]
        v3 == [a |-> 1]
    IN
        /\ PT!ReduceSeq(VMax, <<v1, v2>>, v1) = v3

TestReduceVMax2 ==
    LET
        v1 == [a |-> 0, b |-> 1]
        v2 == [a |-> 1, b |-> 0]
        v3 == [a |-> 1, b |-> 1]
    IN
        /\ PT!ReduceSeq(VMax, <<v1, v2>>, v1) = v3

TestReduceVMax3 ==
    LET
        v1 == [a |-> 0, b |-> 1, c |-> 99]
        v2 == [a |-> 1, b |-> 0, c |-> 0]
        v3 == [a |-> 1, b |-> 1, c |-> 99]
    IN
        /\ PT!ReduceSeq(VMax, <<v1, v2>>, v1) = v3

VLessThan(x, y) ==
    LET
        q == Len(x)
    IN
        /\ \A k \in 1..q : x[k] <= y[k]
        /\ \E j \in 1..q : x[j] < y[j]

VEq(x, y) ==
    LET
        q == Len(x)
    IN
    /\ \A k \in 1..q : x[k] = y[k]

VLessThanOrEq(x,y) ==
    \/ VLessThan(x, y)
    \/ VEq(x, y) 

Tests ==
    /\ TestVMax0 /\ TestVMax1 /\ TestVMax2 /\ TestVMax3
    /\ TestReduceVMax1 /\ TestReduceVMax2 /\ TestReduceVMax3

\* ---------------------------------------------------------------------------
\* Behaviours
\* ---------------------------------------------------------------------------
Init == 
    /\ v        = [i \in Procs |-> [j \in Procs |-> IF i=j THEN 1 ELSE 0]]
    /\ inbox    = [k \in Procs |-> <<>>]
    /\ edge     = [a |-> "init", p |-> "none"]


\* Send is only enabled iff Procs < 2 and there is an inbox with space for 
\* messages.
Send(self) ==
    LET
        vclock == v[self]
    IN
        /\ \E p \in {x \in Procs : x # self /\ Len(inbox[x]) <= MaxInboxLength} : 
            /\ inbox' = [inbox EXCEPT ![p] = Append(@, vclock)]  
            /\ v' = [v EXCEPT ![self] = [vclock EXCEPT ![self] = @ + 1]]
            /\ edge' = [[edge EXCEPT !["a"] = "send"] EXCEPT !["p"] = self]

\* Receive is only enabled if there are items to process in the inbox
Receive(self) ==
    LET
        vclock == v[self]
        max_inbox == PT!ReduceSeq(VMax, inbox[self], [k \in Procs |-> 0])
        max_vect == VMax(max_inbox, vclock)
        inc_max_vect == [max_vect EXCEPT ![self] = @ + 1]
    IN
        /\ Len(inbox[self]) > 0
        /\ inbox' = [inbox EXCEPT ![self] = <<>>]
        /\ v' = [v EXCEPT ![self] = inc_max_vect]
        /\ edge' = [[edge EXCEPT !["a"] = "receive"] EXCEPT !["p"] = self]

Internal(self) ==
    LET
        vclock == v[self]
    IN
        /\ v' = [v EXCEPT ![self] = [vclock EXCEPT ![self] = @ + 1]]
        /\ edge' = [[edge EXCEPT !["a"] = "internal"] EXCEPT !["p"] = self]
        /\ UNCHANGED << inbox >>

Run(self) == 
    \/ Send(self)
    \/ Receive(self)
\* Internal Actions explode the state space,
\* so commenting out while looking at graphs
\*    \/ Internal(self)

Next == \E self \in Procs: Run(self)

Fairness == 
    /\ \A p \in Procs : WF_vars(Receive(p))

Spec == /\ Init /\ Tests /\ [][Next]_vars /\ Fairness

=============================================================================
\* Modification History
\* Created by Todd D. Greenwood-Geer
