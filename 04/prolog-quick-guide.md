Quick guide to Prolog
===============================================================================

Examples here use the `SWI-Prolog` interpreter, available for [download](http://www.swi-prolog.org/download/stable) for free.

### Loading files

For example's sake, let's say we have a file `/home/users/lorand/test-prolog/simple.pl`. Once we start the prolog interpreter we can load the file by running the query bellow (we run only the line starting with `-?`, which is the interpreter's way of asking for a query).  

```
% if your file is empty you should see the following input. 
?- ['/home/users/lorand/test-prolog/simple.pl'].
% /home/lorand/test-prolog/simple.pl compiled 0.00 sec, 1 clauses
true.
```

Okay, not we can start adding things to the `simple.pl` file. `.pl` files can contain so called `Clauses.` The simplest of these clauses are called `Facts` and are of the form `$name($terms *)`, where a term can either be a constant(always starts with lowercase), or it can be a variable(always starts with uppercase) e.g:

```prolog
% we interpret this as the entity `bunk` wears suits.
wearsSuits(bunk).

% we interpret this as the entity `mcnulty` likes to drink the entity `jameson`.
drinks(mcnulty, jameson).

% analogous to above.
drinks(bunk, jackdaniels).
```

Now, if we reload the file into the prolog interpreter we can start asking prolog questions based on the facts that we just defined.

```prolog
-? wearsSuits(bunk).
true.

-? drinks(mcnulty, jameson).
true.

-? drinks(mcnulty, beer).
false.

% since instead of `jameson` we typed `Who`, which is a variable, the prolog interpreter
% will try and find a value for the variable `Who` for which the entire predicate is true.
-? drinks(Who, jameson).
Who = mcnulty.

% since we haven't defined anyone who drinks beer, this will return false
-? drinks(SomeoneElse, beer).
false.
```

We can write compound clauses, referred to as `Rules`. As an example, let's try to encode the following [quote](http://www.quotes.net/show-quote/92568) of the character Bunk Moreland from the TV show `The Wire`: *"The Bunk is strictly a suit-and-tie motherfucker."*

Our new `simple.pl` file will look:
```prolog
wearsSuits(bunk).

wearsTies(bunk).

suitAndTieMotherfucker(X) :-
  wearsSuits(X),
  wearsTies(X).
```

If you look at the `suitAndTieMotherfucker` rule, you can see that it enumerates two predicates that should hold true for the variable `X`. Basically, the rule is true if `all` enumerated predicates are true.  

Notice a distinction between a `fact` and a `predicate`. The first line `wearsSuits(bunk).` is a fact because by using the `.` in the `.pl` file we *declare* that predicate `wearsSuits` is true for the value `bunk`. While `wearsSuits(X)`, is a question asking whether or not predicate `wearsSuits` is true for variable `X`.  

Now, if we go to and reload the file in the interpreter we can ask:  

```prolog
?- suitAndTieMotherfucker(bunk).
true.

?- suitAndTieMotherfucker(mcnulty).
false.
```

### Final remark

Your interpreter does not have to be more semantically rich than the above examples. In Prolog you also have numbers, and other types. Here we will only be dealing with string values.

