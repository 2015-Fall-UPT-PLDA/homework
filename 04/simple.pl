% we interpret this as the entity `bunk` wears suits.
wearsSuits(bunk).

wearsTies(bunk).

suitAndTieMotherfucker(X) :-
  wearsSuits(X),
  wearsTies(X).

% we interpret this as the entity `mcnulty` likes to drink the entity `jameson`.
drinks(mcnulty, jameson).

% analogous to above.
drinks(bunk, jackdaniels).

something.