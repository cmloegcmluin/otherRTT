(* functions *)

smithDefactorThenHnf[m_] := hnf[smithDefactor[m]];

colHermiteDefactorThenHnf[m_] := hnf[colHermiteDefactor[m]];

nullSpaceAndBack[m_] := reverseEachRow[NullSpace[reverseEachRow[NullSpace[m]]]];

signPattern[n_] := Drop[Tuples[{1, 0, -1}, n], -Ceiling[(3 ^ n) / 2]];
linCombsToCheck[m_] := Map[Total[m * #, {1}] &, signPattern[Length[m]]];
sadDefactor[m_] := Module[{reduced, linCombs, linCombsDisarmed, maybeDisarmedRow},
  linCombs = linCombsToCheck[m];
  linCombsDisarmed = Map[divideOutGcd, linCombs];
  maybeDisarmedRow = Complement[linCombsDisarmed, linCombs];
  If[Length[maybeDisarmedRow] == 0, m, sadDefactor[Prepend[Drop[m, 1], First[maybeDisarmedRow]]]]
];

sadDefactorThenHnf[m_] := hnf[sadDefactor[m]];

confirmEnfactoredRowReplaced[m_] := Module[{i, enfactoredRowReplaced},
  enfactoredRowReplaced = True;
  For[i = 1, i <= Length[m], i++,
    If[getGcd[m[[i]]] > 1, enfactoredRowReplaced = False]
  ];
  enfactoredRowReplaced
];

handleEnfactored[m_, maybeDisarmedRow_] := Module[{defactored, attemptedReplacementOfEnfactoredRow, i, enfactoredRowReplaced},
  For[i = 1, i <= Length[m], i++,
    attemptedReplacementOfEnfactoredRow = Prepend[Drop[m, {i}], First[maybeDisarmedRow]];
    enfactoredRowReplaced = confirmEnfactoredRowReplaced[attemptedReplacementOfEnfactoredRow];
    If[enfactoredRowReplaced, defactored = enhancedSadDefactor[attemptedReplacementOfEnfactoredRow]];
  ];
  defactored
];

enhancedSadDefactor[m_] := Module[{mNoAllZeros, reduced, linCombs, linCombsDisarmed, maybeDisarmedRow},
  mNoAllZeros = removeUnneededZeroRows[m];
  linCombs = linCombsToCheck[mNoAllZeros];
  linCombsDisarmed = Map[divideOutGcd, linCombs];
  maybeDisarmedRow = Complement[linCombsDisarmed, linCombs];
  If[Length[maybeDisarmedRow] == 0, mNoAllZeros, handleEnfactored[mNoAllZeros, maybeDisarmedRow]]
];

hnfThenEnhancedSadDefactorThenHnf[m_] := hnf[enhancedSadDefactor[hnf[m]]];


(* examples *)

meantone = {{1, 1, 0}, {0, 1, 4}};
twelve = {{12, 19, 28}};
porcupine = {{7, 11, 16}, {22, 35, 51}};
porcupineIrref = {{3, 0, -1}, {0, 3, 5}};
porcupineMusic = {{1, 2, 3}, {0, 3, 5}};
meanHarrWithFlip = {{0, 1, 4, 10}, {1, 0, -4, -13}};
meanHarrWithoutFlip = {{10, 13, 12, 0}, {-1, -1, 0, 3}};
blackwood = {{5, 8, 0}, {0, 0, 1}};
pajara = {{2, 0, 11, 12}, {0, 1, -2, -2}};
marvelSeven = {{1, 0, 0, -5}, {0, 1, 0, 2}, {0, 0, 1, 2}};
marvelEleven = {{1, 0, 0, -5, 12}, {0, 1, 0, 2, -1}, {0, 0, 1, 2, -3}};
crazyThing = {{12, 19, 28}, {26, 43, 60}};
doublyEnfactored = {{17, 16, -4}, {4, -4, 1}};
commonFactorWellHidden = {{6, 5, -4}, {4, -4, 1}};
withRowOfZeros = {{12, 19, 28}, {0, 0, 0}};
rankDeficient = {{1, 0, 0, -5}, {0, 1, 0, 2}, {1, 1, 0, -3}};
rankZero = {{}};


(* execution *)

example = rankZero;

Print["hnf"];
Print[hnf[example]];
Print["rref"];
Print[rref[example]];
Print["irref"];
Print[irref[example]];
Print["nullSpaceAndBack"];
Print[nullSpaceAndBack[example]];
Print["smithDefactor"];
Print[smithDefactor[example]];
Print["smithDefactorThenHnf"];
Print[smithDefactorThenHnf[example]];
Print["sadDefactor"];
Print[sadDefactor[example]];
Print["sadDefactorThenHnf"];
Print[sadDefactorThenHnf[example]];
Print["snf"];
Print[snf[example]];
