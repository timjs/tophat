<!--
Ik probeer zo weinig mogelijk "our" te gebruiken om het wij <-> zij verschil kleiner te maken.
In plaats van "our" gebruik ik "the".

Verder ga ik er bij verschillende dingen wellicht te hard in op de details.
Kunst is om zoveel als mogelijk terug te grijpen naar de dingen die de reviewers positief vinden aan ons paper.
Dat is belangrijk voor jullie om te checken!

Daarbij zit ik nu 26 woorden over de limiet in het algemene deel (dus tot aan het kopje "specific questions").
Iets om rekening mee te houden!

Tekst [tussen blokhaken] ben ik niet tevreden over en zou ik graag anders hebben.

-- TS
-->

# Rebuttal paper #111

We thank the reviewers for their efforts and constructive comments.
We are pleased to read that reviewers consider the paper is "intriguing" and "well written and interesting".
We are glad to hear "the model seems sensible and the provided examples are quite interesting",
and that we are addressing "an important topic that has received too little attention in the PL community".
Also, we will make sure to incorporate all detailed comments in the final version of the paper.

First and foremost, we'd like to apologise naming our model a calculus.
In light of Plotkin's paper from 1973, our model does not meet the requirements to be called a calculus.
Therefore, we will rename our model to a language.
We are grateful for reviewer D to bring this up.

Next to this, reviewers raised three main points:

* The semantics presented is not challenging or special in any way.
* The work does not contain an application of the given semantics
  or a description why it will be usable for formal reasoning.
* Some undesired tasks can be constructed or unwanted effects could happen.

Below we would like to address these three concerns first, after which we answer specific questions of each reviewer.


## Challenge

The challenge in creating this model is indeed not the used techniques,
which are well established and proved their usefulness in computer science.
[The challenge is going back to the roots of workflow and business process modelling,
while adding facilities to specify higher order workflows and generate applications.]
The resulting applications should have automatically generated user interfaces
and no data races despite a multi user environment.

Although the iTasks framework already promises this,
it is a large library [with lots of bells and whistles].
So, in particular, the challenge is to reformulate the iTasks framework and its ideas in a handful of elementary and well-behaved combinators.
The iTasks framework is totally build on top of two "super combinators" called `step` and `parallel`.
Both were created to express every possible collaboration pattern the creators encountered during case studies.
All other simpler combinators are derivations of these two.

For example, `parallel` has the type (in Haskell syntax):
```
parallel
  :: ITask a
  => [ ( ParallelTaskType, ParallelTask a ) ]
  -> [ TaskCont [ ( Int, TaskValue a ) ] ( ParallelTaskType, ParallelTask a ) ]
  -> Task [ ( Int, TaskValue a ) ]
```
Where `ITask` is a type class facilitating (de)serialisability, datatype generic representations,
type information at runtime, and a way to produce user facing editors.
Trimming this combinator down to two elementary combinators (⋈ and ⧫) which,
together with shared memory (■), can model most of its use cases,
is the main challenge solved in this work.


## Application

The analysis that the current work does not apply the semantics is a valid one.
The exclusion of any [proofs] is an intentional one.
In this work we focus on properly introducing the core concepts of TOP,
formally describe them,
and placing this model into the right context by comparing it a large set of other frameworks and algebras.

In an upcoming article, we are using our system to symbolically execute tasks:
"Proving task properties using symbolic TopHat", which is under consideration for IFL'19.
Symbolic execution allows us to prove properties like "breakfast will always be served" (ex 3.1),
and "passengers always get a seat" (ex 2.1).
These kind of properties would not be expressible and provable using a library like the iTasks framework
and need a well described core set of functionality as presented in this work.
Also, symbolic execution allows us to relate traces of inputs to tasks and observations on them,
a suggestion made by reviewer A.

Also, this gives us space to discuss and analyse a bigger case studies for the Dutch tax office and the Dutch coast guard,
which is more mission critical than the examples given in the current work.


## Undesired tasks and effects

### Higher order tasks

As reviewers A and C point out, it is possible to express tasks of higher order types,
which we did not discuss in the paper.
This is an omission which we should fix for the final version of the paper.
Examples given are:

* ⊠(Int -> Int) or □(λx:τ. x)
* ⊠(Task Int) or ⊠(⊠Int)

It is indeed possible to have tasks of functions and tasks of tasks.
On the user interaction part, one could render such editors as a selection menu of functions or tasks already available in the system.
Users could pick one of them, and continue with execution,
such as picking a function to operate on an integer and applying it to a entered integer like such:

t1 := ⊠(Int -> Int) ⋈ ⊠Int ▶︎ λ⟨f,x⟩. □(f x)

Something similar holds for executing a task entered by a user or, more generally, saved by another task.
Here t1 is selected and will be executed in the next normalisation round:

t2 := □(t1) ▶︎ λt. t

This also gives an answer to the missing join operation in the language and is the only way programmers can eliminate tasks.
A top level task can only be eliminated by running the semantics,
as it needs user input.

Saving something else than an basic type in a reference is, however, not allowed by the grammar.
This is a deliberate choice to exclude recursion by using references.
This means the example below are not possible:

* ■l where l : Int -> Int
* ■l where l : Task Int


### Race conditions and distributed systems

Line 363, which states that our model model supports distributed applications,
should never have reached the submitted version.
It is simply not true.
The system can only "generate _multi-user applications_ to support [...] workflows".
Multiple users can interact with an application running on a single server.

There is an important consequence of this choice that we should state more clearly in the paper.
If one takes as a definition for a _data race_ that
_the same program with the same inputs sometimes gives different results_
then this is not possible in TopHat.
The order of execution is completely determined by the order of the inputs,
which we assume to be a serial stream.
Therefore, it is indeed the case that program and environment alternate:
a user gives an input, the system makes some calculations and the user interface will change.
Only then the user can give her next input, etc.

I.e., in the booking example (ex 2.1):
the user who books the seat first gets the seat.
This is exactly the desired behaviour.


## Specific questions

### Speculative evaluation

The speculative evaluation of task continuations in the semantics is needed to express guards.
We acknowledge that taking state into account needs to reestablish memory if the evaluation leads to failure.
A different approach would be move state from the expression layer to the task layer.
We choose not to do this to keep task modelling features and default language features as branching and references completely separate.
We should have mentioned this reasoning in section 5.3.

### Dining philosophers

The dining philosophers are very easy to express using TopHat.
<!-- Definition should be here.  -- TS -->
To express a dynamic version of this problem,
we would need a (restricted) version of recursion.
One could think of built in recursion principle on natural numbers
or a replicate function on tasks.
