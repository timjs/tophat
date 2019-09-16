Formal semantics for Task Oriented Programming.
Article accepted for publication and presentation at [PPDP'19](http://ppdp2019.macs.hw.ac.uk).

## Abstract

Software that models how people work is omnipresent in today's society.
Current languages and frameworks often focus on usability by non-programmers, sacrificing flexibility and high level abstraction.
Task-oriented programming (TOP) is a programming paradigm that aims to provide the desired level of abstraction while still being expressive enough to describe real world collaboration.
It prescribes a declarative programming style to specify multi-user workflows.
Workflows can be higher-order.
They communicate through typed values on a local and global level.
Such specifications can be turned into interactive applications for different platforms, supporting collaboration during execution.
TOP has been around for more than a decade, in the forms of iTasks and mTasks, which are tailored for real-world usability.
So far, it has not been given a formalisation which is suitable for formal reasoning.

In this paper we give a description of the TOP paradigm and then decompose its rich features into elementary language elements, which makes them suitable for formal treatment.
We use the simply typed lambda-calculus, extended with pairs and references, as a base language.
On top of this language, we develop TopHat, a language for modular interactive workflows.
We describe TopHat by means of a layered semantics.
These layers consist of multiple big-step evaluations on expressions, and two labelled transition systems, handling user inputs.

With TopHat we prepare a way to formally reason about TOP languages and programs.
This approach allows for comparison with other work in the field.
We have implemented the semantic rules of TopHat in Haskell, and the task layer on top of the iTasks framework.
This shows that our approach is feasible, and lets us demonstrate the concepts by means of illustrative case studies.
TOP has been applied in projects with the Dutch coast guard, tax office, and navy.
Our work matters because formal program verification is important for mission-critical software, especially for systems with concurrency.

## Article

Can be found in [main.pdf](main.pdf).

## Appendices

Can be found in [appendix.pdf](appendix.pdf).
