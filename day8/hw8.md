# FOCS Homework for Day 9

You may edit your answers into this file, or add a separate file in the same directory.

If you add a separate file, please include the following at the top:

```
Student Name: Leon Lam [change to your name]
Check one:
[X] I completed this assignment without assistance or external resources.
[ ] I completed this assignment with assistance from ___
   and/or using these external resources: ___
```

## 1. For each of the following languages, decide whether it is regular

For each of the following languages, decide whether it is regular.  If it is regular, give a regular expression or finite automaton that recognizes the language.  If it is not regular, demonstrate that using the pumping lemma.

a) Strings containing only the symbol a whose length is a power of 2 (*i.e.* length 2^n)

[The strings `a`, `aa`, `aaaa`, and `aaaaaaaa` are in this language; the string `aaaaa` is not.]

Not regular.

For any finite automaton with p states that recognizes strings with length 2^n where 2^n > p, there must be a loop within the first p characters of the string. There is then a number m which we multiply the loop by to make the total length of the string greater than 2^n, yet said string will still be accepted.

b) All strings with an equal number of occurrences of the substrings `01` and `10`.

[010 is in this language; `000110` is in the language; `0101010` is in the language; but `010101` is not.]

Regular.

(0+1+0+)* U (1+0+1+)*

c) All strings (over {0,1}) consisting of a substring _w_ followed by the reverse of the substring.

[The strings `00100100` and `11110101011010101111` are in this language; the strings `00100` and `010101 `are not.]

Not regular. Finite automata have no memory, so they can't 'check' that the second half of the string is reversed. A pushdown automaton should be able to, though.


## 2. Play the pumping game

Play the **pumping game** (referenced on the [Day 8 page](https://sites.google.com/site/focs16fall/in-class-exercises/day-8) and also found at [http://weitz.de/pump/](http://weitz.de/pump/)).  Solve at least two puzzles from that page (that do NOT appear in question 1, above) and provide the word you chose, the substring the computer chose, and your successfully pumped string.

Notation notes:

- The notation |w| sub a means the number of `a`'s in the word _w_.
- _a_^_n_ means _n_ occurrences of `a` (e.g. _a_^8 is `aaaaaaaa`)

If you have other questions about notation (or anything else), please post them to [Piazza](https://piazza.com) so that we can clarify for everyone.

Exercise 2:
a­nbn was the alleged regular expression, I chose a12b12, the computer chose aaaabbbb, and my pumped string was a16b4a4b16.

Exercise 8:
a­nb2n was the alleged regular expression, I chose a2b4, the computer chose a2b2, and my pumped string was (a2b2)3b2.


## 3. Create a PDA

For one of the non-regular languages in problem 1 or 2 above, create a PDA (preferably in JFLAP) and include it with your completed homework.

Problem 16 in the Pumping game has anban as a nonregular language. We can make a PDA that recognizes this by a loop that pushes 'a' to stack each time we see one. If we see a 'b', we transition into a new state where we pop from the stack if we see an 'a', and the only accepting state is when the stack is empty and there are no longer any letters in the string.

## 4. Reading

Optionally read Sipser pp. 101â€“125.

Optionally read Stuart pp. 128â€“134.

## 5. Install gprolog

Please download and install [gprolog](http://www.gprolog.org) before coming to class:

**Ubuntu**:

	$ sudo apt-get install gprolog

**Mac**, with [Homebrew](http://brew.sh) installed:

	$ brew install gnu-prolog

**Mac** without Homebrew, and **Windows**:

- Follow the instructions at [http://www.gprolog.org/#download](http://www.gprolog.org/#download).
