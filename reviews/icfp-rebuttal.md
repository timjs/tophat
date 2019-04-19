<!--
Ik probeer zo weinig mogelijk "our" te gebruiken om het wij <-> zij verschil kleiner te maken.
In plaats van "our" gebruik ik "the".

Verder ga ik er bij verschillende dingen wellicht te hard in op de details.
Kunst is om zoveel als mogelijk terug te grijpen naar de dingen die de reviewers positief vinden aan ons paper.
Dat is belangrijk voor jullie om te checken!

Daarbij zit ik nu zo'n 100 woorden over de limiet van 1000 in het algemene deel (dus tot aan het kopje "specific questions").
Iets om rekening mee te houden!

Ik vraag me even af op welk punt we nog het beste de "de positieve opmerkingen van de reviewers [kunnen] meenemen",
zoals Rinus aangaf:

> TOP is, zoals de reviewers aangeven, een belangrijk concept die een oplossing biedt voor interactieve applicaties (Achilles hiel van FP),
> met iTasks worden complexe commerciele applicaties gemaakt (dus het is praktisch bruikbaar),
> een semantiek die het redeneren over programma's mogelijk maakt is belangrijk, maar niet eenvoudig door de vele mogelijkheden,
> en daarom is TopHat waarbij jullie je bewust beperken een eerste noodzakelijke stap.

Verder zijn er gaten voor een implementatie van de dining philosophers.
Kun jij die toevoegen Markus?
En heb ik de laatste vraag van reviewer D nog niet beantwoord.

-- TS
-->

# Rebuttal paper #111

We thank the reviewers for their efforts and constructive comments.
We are glad to hear that the reviewers consider the paper "intriguing" and "well written and interesting",
that "the model seems sensible and the provided examples are quite interesting",
and that we are addressing "an important topic that has received too little attention in the PL community".

First and foremost we are grateful for reviewer D for bringig up that in light
of Plotkin's paper from 1973, our model does not meet the requirements to be
called a calculus.
We will call it a domain specific language, or just language.

The reviewers concerns fall into three main categories:

* The semantics presented is not challenging or special.
* The work does not contain an application of the given semantics.
* Some undesired tasks can be constructed or unwanted effects could happen.

We will address these concerns, after which we will answer specific questions of each reviewer.
Naturally, all comments will be addressed in the final version of the paper.


## General concerns

### Challenge

As the reviewers point out,
the challenge in creating our language is neither the used techniques,
nor proving soundness.
This should be reflected in the paper.

The main challenge we faced was stripping down iTasks into a handful of
elementary and well-behaved combinators while retaining the essential features
of TOP.

iTasks is built on the two feature-rich combinators `step` and `parallel`.
Both were designed to express every possible collaboration pattern the creators encountered during case studies.
All other combinators are derived from these two.

For example, `parallel` has the following type, given in Haskell syntax:
```
parallel
  :: ITask a
  => [ ( ParallelTaskType, ParallelTask a ) ]
  -> [ TaskCont [ ( Int, TaskValue a ) ] ( ParallelTaskType, ParallelTask a ) ]
  -> Task [ ( Int, TaskValue a ) ]
```
Where `ITask` is a type class that provides serialisation, datatype generic representations,
run-time type information, and generation of graphical editors.
The main challenge solved in this work is
trimming this combinator down to two elementary combinators (⋈ and ⧫) which,
together with shared memory (■), can model most of its use cases.
We did not give this example in section 1.4, where it belongs.

Furthermore, we were able to significantly simplify the step combinator using the
insight that the fail task (☇) is a basic task which will never have an observable value
and can be used for guards.

Also, our system simplifies the notion of editors and connects them to the already existing notion of widgets.

All these points are not sufficiently emphasized in the paper.


### Application

The analysis that the current work does not apply the semantics is a valid one.
The exclusion of any application is an intentional one.
In this work, we focus on properly introducing the core concepts of TOP,
linking them to a formal description,
showing this description is sane,
and placing the resulting model into the right context by comparing it a fair set of other frameworks and algebras.
These four things lead to a holistic description of TOP which can be used for further research as well as implementation.
Summarising: the presented system is "useful elsewhere", as indicated by reviewer A.

In an upcoming article, we are using our system to symbolically execute tasks.
<!-- Moet zo'n verwijzing er in?  --TS -->
["Proving task properties using symbolic TopHat", under consideration for IFL'19.]
Symbolic execution allows us to prove properties like "breakfast will always be served" (ex 3.1),
and "passengers always get a seat" (ex 2.1).
It will be possible to relate traces of inputs to tasks and observations on them,
a suggestion made by reviewer A.
These kind of properties would not be expressible and provable using a library like the iTasks framework.
They need a well described core set of functionality as presented in this work.

A split also gives us the opportunity to discuss and analyse bigger case studies from the Dutch tax office and the Dutch coast guard.
They are certainly more mission critical than the small examples given in the current work.


### Undesired tasks and effects

#### Higher order tasks

As reviewers A and C point out, it is possible to express tasks of higher order types,
which we did not discuss in the paper.
This is an omission which we should fix for the final version.
Examples given are:

* ⊠(Int -> Int) or □(λx:τ. x)
* ⊠(Task Int) or ⊠(⊠Int)

It is indeed possible to have tasks of functions and tasks of tasks.
On the user interaction part, one could render above editors as a selection menu of functions or tasks already available in the system.
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


#### Race conditions and distributed systems

Line 363, which states that our model supports distributed applications,
should never have reached the submitted version.
It is simply not true.
The system can only "generate _multi-user applications_ to support [...] workflows":
multiple users can interact with an application running on a single server.

There is an important consequence of this choice that we should state more clearly in the paper.
If one takes as a definition for a data race that
_the same program with the same inputs sometimes gives different results_
then this is not possible in TopHat.
The order of execution is completely determined by the order of the inputs,
which we assume to be a serial stream.
Therefore, it is indeed the case that program and environment alternate as mentioned by reviewer C:
a user gives an input, the system makes some calculations and the user interface will change.
Only then the user can give her next input, etc.
I.e., in the booking example (ex 2.1):
the user who books the seat first gets the seat.
This is exactly the desired behaviour.


## Specific questions

### Reviewer A

> You say you "show that the normalisation semantics is a big-step semantics".
> Which property is that, and why is it important?
> Why does having state complicate a big-step semantics?

This is an leftover and should not have made it into this version.
We will remove it.


> Could you encode BPEL in TopHat? If not, which features does BPEL
> support that you do not? (E.g., cycles?)

It should be possible to express most BPEL programs in TopHat
as BPEL supports the same basic compositions as TopHat (sequence and parallel)
and the same structured programming constructs.
Only loop constructs are not supported, as TopHat does not have recursion.

An embedding in the other direction, however, would not be possible.
BPEL lacks the higher order constructs which TopHat has.


> You are able to write the smoker program simply because your semantics eats all the complexity.
> What would dining philosophers look like in your system?
> It seems you cannot write a version of it that dynamically determines the number of philosophers.
> What might you need to add to the language to support that?

The dining philosophers are very easy to express using TopHat.
<!-- Definition should be here.  -- TS -->
To express a dynamic version of this problem,
we would need a (restricted) version of recursion.
One could think of built in recursion principle on natural numbers
or a replicate function on tasks.


### Reviewer C

#### On speculative evaluation

The speculative evaluation of task continuations in the semantics is needed to express guards.
We acknowledge that taking state into account needs to reestablish memory if the evaluation leads to failure.
A different approach would be move state from the expression layer to the task layer.
We choose not to do this to keep task modelling features and default language features as branching and references completely separate.
We should have mentioned this reasoning in section 5.3.


#### On the notion of time in comparison to FRP

The main difference between time in TopHat and in FRP is that
behaviours in FRP are explicitly functions from time to values.
In TopHat, tasks have a notion of order, but do not explicitly depend on time.

This doesn't mean, however, that task cannot react on a time value, as is done in example 4.5.
Takeaway is that _a clock in TopHat is just a user which updates a shared time value on a regular base_.
We will explicitly mention this in the paper in example 4.5 and in section 7.4.


### Reviewer D

> 1) What is challenging/surprising about constructing TOPHAT?

We hope to have answered this question in the general section,
in the paragraphs about "Challenge".

> 2) Could you please explain what kind of properties of iTasks programs you intend to prove with TOPHAT
>    and how its design helps this process?

<!-- How does the design help??  --TS -->
