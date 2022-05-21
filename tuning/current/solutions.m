(* OPTIMIZATION POWER = \[Infinity] (MINIMAX) OR COMPLEXITY NORM POWER = 1 LEADING TO DUAL NORM POWER \[Infinity] ON PRIMES (MAX NORM) *)

(* covers unchanged-octave diamond minimax-U "minimax", minimax-S "TOP", pure-octave-stretched minimax-S "POTOP", 
minimax-PNS "BOP", minimax-ZS "Weil", minimax-QZS "Kees" *)
(* based on https://github.com/keenanpepper/tiptop/blob/main/tiptop.py *)
optimizeGeneratorsTuningMapSemianalyticalMaxPolytope[{
  temperedSideGeneratorsPart_,
  temperedSideMappingPart_,
  justSideGeneratorsPart_,
  justSideMappingPart_,
  eitherSideIntervalsPart_,
  eitherSideMultiplierPart_
}] := Module[
  {
    temperedSideMinusGeneratorsPart,
    justSide,
    
    generatorCount,
    maxCountOfNestedMinimaxibleDamages,
    minimaxTunings,
    minimaxLockForTemperedSide,
    minimaxLockForJustSide,
    undoMinimaxLocksForTemperedSide,
    undoMinimaxLocksForJustSide,
    uniqueOptimumTuning
  },
  
  temperedSideMinusGeneratorsPart = Transpose[temperedSideMappingPart.eitherSideIntervalsPart.eitherSideMultiplierPart];
  justSide = Transpose[getSide[justSideGeneratorsPart, justSideMappingPart, eitherSideIntervalsPart, eitherSideMultiplierPart]];
  
  (* our goal is to find the generator tuning map not merely with minimaxed damage, 
  but where the next-highest damage is minimaxed as well, and in fact every next-highest damage is minimaxed, all the way down.
  the tuning which has all damages minimaxed within minimaxed all the way down like this we can call a "nested-minimax".
  it's the only sensible optimum given a desire for minimax damage, so in general we can simply still call it "minimax".
  though people have sometimes distinguished this tuning from the range of minimax tunings with a prefix, 
  such as "TIPTOP tuning" versus "TOP tunings", although there is no value in "TOP tunings" given the existence of "TIPTOP",
  so you may as well just keep calling it "TOP" and refine its definition. anyway...
  
  the `findAllNestedMinimaxTuningsFromPolytopeVertices` function this function calls may come back with more than one result. 
  the clever way we compute a nested-minimax uses the same polytope vertex searching method used for the that first pass, but now with a twist.
  so in the basic case, this method finds the vertices of a tuning polytope for a temperament.
  this is the area inside of which the targeted intervals are as close as possible to just (by the definition of minimax damage, anyway).
  so now, instead of running it on the case of the original temperament versus JI, we run it on a distorted version of this case.
  specifically, we run it on a case distorted so that the previous minimaxes are locked down.
  
  we achieve this by picking one of these minimax tunings and offset the just side by it. 
  it doesn't matter which minimax tuning we choose, by the way; they're not sorted, and we simply take the first one.
  the corresponding distortion to the tempered side is trickier, 
  involving the differences between this arbitrarily-chosen minimax tuning and each of the other minimax tunings.
  note that after this distortion, the original rank and dimensionality of the temperament will no longer be recognizable.
  
  we then we search for polytope vertices of this minimax-locked distorted situation.
  and we repeatedly do this until we eventually find a unique, nested-minimax optimum. 
  once we've done that, though, our result isn't in the form of a generators tuning map yet. it's still distorted.
  well, with each iteration, we've been keeping track of the distortion applied, so that in the end we could undo them all.
  after undoing those, voilà, we're done! *)
  
  (* the mapped and weighted targeted intervals on one side, and the just and weighted targeted intervals on the other;
  note that just side goes all the way down to tuning map level (logs of primes), including the generators
  while the tempered side isn't tuned, but merely mapped. that's so we can solve for the rest of it, 
  i.e. the generators AKA its tunings *)
  
  (* the same as rank here, but named this for correlation with elsewhere in this code *)
  generatorCount = Last[Dimensions[temperedSideMinusGeneratorsPart]];
  
  (* this is too complicated to be explained here and will be explained later *)
  maxCountOfNestedMinimaxibleDamages = 0;
  
  (* the candidate generator tuning maps which minimax damage to the targets*)
  minimaxTunings = findAllNestedMinimaxTuningsFromPolytopeVertices[
    temperedSideMinusGeneratorsPart,
    justSide,
    maxCountOfNestedMinimaxibleDamages
  ];
  maxCountOfNestedMinimaxibleDamages = generatorCount + 1;
  
  (* no minimax-damage-locking transformations yet, so the transformation trackers are identities 
  per their respective operations of matrix multiplication and addition *)
  undoMinimaxLocksForTemperedSide = IdentityMatrix[generatorCount];
  undoMinimaxLocksForJustSide = Table[{0}, generatorCount];
  
  While[
    (* a unique optimum has not yet been found *)
    Length[minimaxTunings] > 1,
    
    (* arbitrarily pick one of the minimax damage generator tuning maps; the first one from this unsorted list *)
    minimaxLockForJustSide = First[minimaxTunings];
    (* list of differences between each other minimax generator tuning map and the first one; 
    note how the range starts on index 2 in order to skip the first one *)
    minimaxLockForTemperedSide = Map[Flatten, Transpose[Map[
      Part[minimaxTunings, #] - minimaxLockForJustSide&,
      Range[2, Length[minimaxTunings]]
    ]]];
    
    (* apply the minimax-damage-locking transformation to the just side, and track it to undo later *)
    justSide -= temperedSideMinusGeneratorsPart.minimaxLockForJustSide;
    undoMinimaxLocksForJustSide += undoMinimaxLocksForTemperedSide.minimaxLockForJustSide;
    
    (* apply the minimax-damage-locking transformation to the tempered side, and track it to undo later *)
    (* this would be a .= if Wolfram supported an analog to += and -= *)
    (* unlike how it is with the justSide, the undo operation is not inverted here; 
    that's because we essentially invert it in the end by left-multiplying rather than right-multiplying *)
    temperedSideMinusGeneratorsPart = temperedSideMinusGeneratorsPart.minimaxLockForTemperedSide;
    undoMinimaxLocksForTemperedSide = undoMinimaxLocksForTemperedSide.minimaxLockForTemperedSide;
    
    (* search again, now in this transformed state *)
    minimaxTunings = findAllNestedMinimaxTuningsFromPolytopeVertices[temperedSideMinusGeneratorsPart, justSide, maxCountOfNestedMinimaxibleDamages];
    maxCountOfNestedMinimaxibleDamages += generatorCount + 1;
  ];
  
  uniqueOptimumTuning = First[minimaxTunings];
  
  SetAccuracy[Flatten[
    (* here's that left-multiplication mentioned earlier *)
    undoMinimaxLocksForTemperedSide.uniqueOptimumTuning + undoMinimaxLocksForJustSide
  ], 10]
];

findAllNestedMinimaxTuningsFromPolytopeVertices[temperedSideMinusGeneratorsPart_, justSide_, maxCountOfNestedMinimaxibleDamages_] := Module[
  {
    targetCount,
    generatorCount,
    nthmostMinDamage,
    vertexConstraintAs,
    targetIndices,
    candidateTunings,
    sortedDamagesByCandidateTuning,
    candidateTuning,
    sortedDamagesForThisCandidateTuning,
    newCandidateTunings,
    newSortedDamagesByCandidateTuning
  },
  
  (* in the basic case where no minimax-damage-locking transformations have been applied, 
  these will be the same as the count of original targeted intervals and the rank of the temperament, respectively *)
  targetCount = First[Dimensions[temperedSideMinusGeneratorsPart]];
  generatorCount = Last[Dimensions[temperedSideMinusGeneratorsPart]];
  
  (* here's the meat of it: solving a linear problem for each vertex of the of tuning polytope;
  more details on this in the constraint matrix gathering function's comments below *)
  candidateTunings = {};
  vertexConstraintAs = getTuningPolytopeVertexConstraintAs[generatorCount, targetCount];
  Do[
    AppendTo[
      candidateTunings,
      Quiet[Check[
        LinearSolve[
          N[vertexConstraintA.temperedSideMinusGeneratorsPart, linearSolvePrecision],
          N[vertexConstraintA.justSide, linearSolvePrecision]
        ],
        "err"
      ]
      ]],
    {vertexConstraintA, vertexConstraintAs}
  ];
  (* ignore the problems that are singular and therefore have no solution *)
  candidateTunings = Select[candidateTunings, !TrueQ[# == "err"]&];
  
  (* each damages list is sorted in descending order; 
  the list of lists itself is sorted corresponding to the candidate tunings*)
  sortedDamagesByCandidateTuning = Quiet[Map[
    Function[
      {candidateTuning},
      (* note that because of being sorted by size, this is no longer sorted by which target the damage applies to *)
      ReverseSort[SetAccuracy[Flatten[Abs[
        temperedSideMinusGeneratorsPart.candidateTuning - justSide
      ]], linearSolvePrecision]]
    ],
    candidateTunings
  ]];
  
  (*     
  here we're iterating by index of the targeted intervals, 
  repeatedly updating the lists candidate tunings and their damages,
  (each pass the list gets shorter, hopefully eventually hitting length 1, at which point a unique tuning has been found,
  but this doesn't necessarily happen, and if it does, it's handled by the function that calls this function)
  until by the final pass they are what we want to return.
  
  there's an inner loop by candidate tuning, and since that list is shrinking each time, the size of the inner loop changes.
  in other words, we're not covering an m \[Times] n rectangular grid's worth of possibilities; more like a jagged triangle.
  
  note that because the damages have all been sorted in descending order,
  these target "indices" do not actually correspond to an individual targeted interval.
  that's okay though because here it's not important which target each of these damages is for.
  all that matters is the size of the damages.
  once we find the tuning we want, we can easily compute its damages list sorted by target when we need it later; that info is not lost.
  
  and note that we don't iterate over *every* target "index".
  we only check as many targets as we could possibly nested-minimax by this point.
  that's why this method doesn't simply always return a unique nested-minimax tuning each time.
  this is also why the damages have been sorted in this way
  so first we compare each tuning's actual minimum damage,
  then we compare each tuning's second-closest-to-minimum damage,
  then compare each third-closest-to-minimum, etc.
  the count of target indices we iterate over is a running total; 
  each time it is increased, it goes up by the present generator count plus 1.
  why it increases by that amount is a bit of a mystery to me, but perhaps someone can figure it out and let me know.
  *)
  targetIndices = Range[Min[maxCountOfNestedMinimaxibleDamages + generatorCount + 1, targetCount]];
  Do[
    newCandidateTunings = {};
    newSortedDamagesByCandidateTuning = {};
    
    (* this is the nth-most minimum damage across all candidate tunings,
    where the actual minimum is found in the 1st index, the 2nd-most minimum in the 2nd index,
    and we index it by target index *)
    nthmostMinDamage = Min[Map[Part[#, targetIndex]&, sortedDamagesByCandidateTuning]];
    
    Do[
      (* having found the minimum damage for this target index, we now iterate by candidate tuning index *)
      candidateTuning = Part[candidateTunings, minimaxTuningIndex];
      sortedDamagesForThisCandidateTuning = Part[sortedDamagesByCandidateTuning, minimaxTuningIndex];
      
      If[
        (* and if this is one of the tunings which is tied for this nth-most minimum damage,
        add it to the list of those that we'll check on the next iteration of the outer loop 
        (and add its damages to the corresponding list) 
        note the tiny tolerance factor added to accommodate computer arithmetic error problems *)
        Part[sortedDamagesForThisCandidateTuning, targetIndex] <= nthmostMinDamage + 0.000000001,
        
        AppendTo[newCandidateTunings, candidateTuning];
        AppendTo[newSortedDamagesByCandidateTuning, sortedDamagesForThisCandidateTuning]
      ],
      
      {minimaxTuningIndex, Range[Length[candidateTunings]]}
    ];
    
    candidateTunings = newCandidateTunings;
    sortedDamagesByCandidateTuning = newSortedDamagesByCandidateTuning,
    
    {targetIndex, targetIndices}
  ];
  
  (* if duplicates are not deleted, then when differences are checked between tunings,
  some will come out to all zeroes, and this causes a crash *)
  DeleteDuplicates[
    candidateTunings,
    Function[{tuningA, tuningB}, AllTrue[MapThread[#1 == #2&, {tuningA, tuningB}], TrueQ]]
  ]
];

getTuningPolytopeVertexConstraintAs[generatorCount_, targetCount_] := Module[
  {vertexConstraintA, vertexConstraintAs, targetCombinations, directionPermutations},
  
  vertexConstraintAs = {};
  
  (* here we iterate over every combination of r (rank = generator count, in the basic case) targets 
  and for each of those combinations, looks at all permutations of their directions. 
  these are the vertices of the maximum damage tuning polytope. each is a generator tuning map. the minimum of these will be the minimax tuning.
  
  e.g. for target intervals 3/2, 5/4, and 5/3, with 2 generators, we'd look at three combinations (3/2, 5/4) (3/2, 5/3) (5/4, 5/3)
  and for the first combination, we'd look at both 3/2 \[Times] 5/4 = 15/8 and 3/2 \[Divide] 5/4 = 6/5.
  
  then what we do with each of those combo perm vertices is build a constraint matrix. 
  we'll apply this constraint matrix to a typical linear equation of the form Ax = b, 
  where A is a matrix, b is a vector, and x is another vector, the one we're solving for.
  in our case our matrix A is M, our mapping, b is our primes tuning map p, and x is our generators tuning map g.
  
  e.g. when the targets are just the primes (and thus an identity matrix we can ignore),
  and the temperament we're tuning is 12-ET with M = [12 19 28] and standard interval basis so p = [log₂2 log₂3 log₂5],
  then we have [12 19 28][g₁] = [log₂2 log₂3 log₂5], or a system of three equations:
  
  12g₁ = log₂2
  19g₁ = log₂3
  28g₁ = log₂5
  
  Obviously not all of those can be true, but that's the whole point: we linear solve for the closest possible g₁ that satisfies all well.
  
  Now suppose we get the constraint matrix [1 1 0]. We multiply both sides of the setup by that:
  
  [1 1 0][12 19 28][g₁] = [1 1 0][log₂2 log₂3 log₂5]
  [31][g₁] = [log₂2 + log₂3]
  
  This leaves us with only a single equation:
  
  31g₁ = log₂6
  
  Or in other words, this tuning makes 6/1 pure, and divides it into 31 equal parts.
  If this temperament's mapping says it's 12 steps to 2/1 and 19 steps to 3/1, and it takes 31 steps to a pure 6/1,
  that implies that whatever damage there is on 2/1 is equal to whatever damage there is on 3/1, since they apparently cancel out.
  
  This constraint matrix [1 1 0] means that the target combo was 2/1 and 3/1, 
  because those are the targets corresponding to its nonzero elements.
  And both nonzero elements are +1 meaning that both targets are combined in the same direction.
  If the targeted intervals list had been [3/2, 4/3, 5/4, 8/5, 5/3, 6/5] instead, and the constraint matrix [1 0 0 0 -1 0],
  then that's 3/2 \[Divide] 5/3 = 5/2.
  
  The reason why we need all the permutations is because they're actually anchored 
  with the first targeted interval always in the super direction.
  *)
  targetCombinations = DeleteDuplicates[Map[Sort, Select[Tuples[Range[1, targetCount], generatorCount + 1], DuplicateFreeQ[#]&]]];
  Do[
    directionPermutations = Tuples[{1, -1}, generatorCount];
    Do[
      
      vertexConstraintA = Table[Table[0, targetCount], generatorCount];
      
      Do[
        vertexConstraintA[[generatorIndex, Part[targetCombination, 1]]] = 1;
        vertexConstraintA[[generatorIndex, Part[targetCombination, generatorIndex + 1]]] = Part[directionPermutation, generatorIndex],
        
        {generatorIndex, Range[generatorCount]}
      ];
      
      AppendTo[vertexConstraintAs, vertexConstraintA],
      
      {directionPermutation, directionPermutations}
    ],
    
    {targetCombination, targetCombinations}
  ];
  
  If[
    generatorCount == 1,
    Do[
      vertexConstraintA = {Table[0, targetCount]};
      vertexConstraintA[[1, targetIndex]] = 1;
      
      AppendTo[vertexConstraintAs, vertexConstraintA],
      
      {targetIndex, Range[targetCount]}
    ]
  ];
  
  (* count should be the product of the indices count and the signs count, plus the r == 1 ones *)
  vertexConstraintAs
];


(* OPTIMIZATION POWER = 1 (MINIMSUM) OR COMPLEXITY NORM POWER = \[Infinity] LEADING TO DUAL NORM POWER 1 ON PRIMES (TAXICAB NORM) *)

(* no historically described tunings use this *)
(* based on https://en.xen.wiki/w/Target_tunings#Minimax_tuning, 
where unchanged-octave diamond minimax-U "minimax" is described;
however, this computation method is in general actually a solution for minisum tunings, not minimax tunings. 
it only lucks out and works for minimax due to the pure-octave-constraint 
and nature of the tonality diamond targeted interval set,
namely that the places where damage to targets are equal is the same where other targets are pure.
*)
optimizeGeneratorsTuningMapAnalyticalSumPolytope[{
  temperedSideGeneratorsPart_,
  temperedSideMappingPart_,
  justSideGeneratorsPart_,
  justSideMappingPart_,
  eitherSideIntervalsPart_,
  eitherSideMultiplierPart_
}] := Module[
  {
    generatorCount,
    
    unchangedIntervalSetIndices,
    candidateUnchangedIntervalSets,
    normalizedCandidateUnchangedIntervalSets,
    filteredNormalizedCandidateUnchangedIntervalSets,
    candidateOptimumGeneratorAs,
    candidateOptimumGeneratorsTuningMaps,
    candidateOptimumGeneratorTuningMapDamages,
    
    optimumGeneratorsTuningMapIndices,
    optimumGeneratorsTuningMapIndex
  },
  
  generatorCount = First[Dimensions[temperedSideMappingPart]]; (* First[], not Last[], because it's not transposed here. *)
  
  unchangedIntervalSetIndices = Subsets[Range[Length[Transpose[eitherSideIntervalsPart]]], {generatorCount}];
  candidateUnchangedIntervalSets = Map[Map[Transpose[eitherSideIntervalsPart][[#]]&, #]&, unchangedIntervalSetIndices];
  normalizedCandidateUnchangedIntervalSets = Map[canonicalCa, candidateUnchangedIntervalSets];
  filteredNormalizedCandidateUnchangedIntervalSets = DeleteDuplicates[Select[normalizedCandidateUnchangedIntervalSets, MatrixRank[#] == generatorCount&]];
  candidateOptimumGeneratorAs = Select[Map[
    getGeneratorsAFromUnchangedIntervals[temperedSideMappingPart, #]&,
    filteredNormalizedCandidateUnchangedIntervalSets
  ], Not[# === Null]&];
  candidateOptimumGeneratorsTuningMaps = Map[justSideGeneratorsPart.#&, candidateOptimumGeneratorAs];
  candidateOptimumGeneratorTuningMapDamages = Map[
    getSumDamageOrGetSumPrimesAbsError[
      #,
      temperedSideMappingPart,
      justSideGeneratorsPart,
      justSideMappingPart,
      eitherSideIntervalsPart,
      eitherSideMultiplierPart
    ]&,
    candidateOptimumGeneratorsTuningMaps
  ];
  
  optimumGeneratorsTuningMapIndices = Position[candidateOptimumGeneratorTuningMapDamages, Min[candidateOptimumGeneratorTuningMapDamages]];
  If[
    Length[optimumGeneratorsTuningMapIndices] == 1,
    
    (* result is unique; done *)
    optimumGeneratorsTuningMapIndex = First[First[Position[candidateOptimumGeneratorTuningMapDamages, Min[candidateOptimumGeneratorTuningMapDamages]]]];
    First[candidateOptimumGeneratorsTuningMaps[[optimumGeneratorsTuningMapIndex]]],
    
    (* result is non-unique, will need to handle otherwise *)
    Null
  ]
];

getSumDamageOrGetSumPrimesAbsError[
  temperedSideGeneratorsPart_,
  temperedSideMappingPart_,
  justSideGeneratorsPart_,
  justSideMappingPart_,
  eitherSideIntervalsPart_,
  eitherSideMultiplierPart_
] := Module[
  {temperedSide, justSide},
  
  temperedSide = First[getSide[temperedSideGeneratorsPart, temperedSideMappingPart, eitherSideIntervalsPart, eitherSideMultiplierPart]];
  justSide = First[getSide[justSideGeneratorsPart, justSideMappingPart, eitherSideIntervalsPart, eitherSideMultiplierPart]];
  
  Total[getAbsErrors[temperedSide, justSide]]
];

getAbsErrors[temperedSide_, justSide_] := Abs[getErrors[temperedSide, justSide]];

getErrors[temperedSide_, justSide_] := N[
  Map[
    If[Quiet[PossibleZeroQ[#]], 0, #]&,
    temperedSide - justSide
  ],
  absoluteValuePrecision
];

getGeneratorsAFromUnchangedIntervals[ma_, unchangedIntervalEigenvectors_] := Module[
  {mappedUnchangedIntervalEigenvectors},
  
  mappedUnchangedIntervalEigenvectors = ma.Transpose[unchangedIntervalEigenvectors];
  
  If[
    Det[mappedUnchangedIntervalEigenvectors] == 0,
    Null,
    Transpose[unchangedIntervalEigenvectors].Inverse[mappedUnchangedIntervalEigenvectors]
  ]
];


(* OPTIMIZATION POWER = 2 (MINISOS) OR COMPLEXITY NORM POWER = 2 LEADING TO DUAL NORM POWER 2 ON PRIMES (EUCLIDEAN NORM) *)

(* covers unchanged-octave diamond minisos-U "least squares", minimax-ES "TE", pure-octave-stretched minimax-ES "POTE",
minimax-NES "Frobenius", minimax-ZES "WE", minimax-PNES "BE" *)
optimizeGeneratorsTuningMapAnalyticalMagPseudoinverse[{
  temperedSideGeneratorsPart_,
  temperedSideMappingPart_,
  justSideGeneratorsPart_,
  justSideMappingPart_,
  eitherSideIntervalsPart_,
  eitherSideMultiplierPart_
}] := Module[
  {temperedSideMinusGeneratorsPart, justSide},
  
  temperedSideMinusGeneratorsPart = temperedSideMappingPart.eitherSideIntervalsPart.eitherSideMultiplierPart;
  justSide = getSide[justSideGeneratorsPart, justSideMappingPart, eitherSideIntervalsPart, eitherSideMultiplierPart];
  
  First[justSide.Transpose[temperedSideMinusGeneratorsPart].Inverse[temperedSideMinusGeneratorsPart.Transpose[temperedSideMinusGeneratorsPart]]]
];


(* GENERAL OPTIMIZATION POWER (MINISOP) OR GENERAL COMPLEXITY NORM POWER (P-NORM) *)

(* covers minimax-QZES "KE", unchanged-octave minimax-ES "CTE" *)
optimizeGeneratorsTuningMapNumericalPowerSolver[
  parts_,
  normPower_,
  unchangedIntervals_,
  periodsPerOctave_
] := Module[
  {solution},
  
  solution = getNumericalSolution[parts, normPower, unchangedIntervals, periodsPerOctave];
  
  First[First[parts]] /. Last[solution]
];

(* no historically described tunings use this *)
(* this is the fallback for when optimizeGeneratorsTuningMapAnalyticalSumPolytope fails to find a unique solution *)
optimizeGeneratorsTuningMapNumericalPowerLimitSolver[
  parts_,
  normPowerLimit_,
  unchangedIntervals_,
  periodsPerOctave_
] := Module[
  {
    normPowerPower,
    normPower,
    previousAbsErrorMagnitude,
    absErrorMagnitude,
    previousSolution,
    solution
  },
  
  normPowerPower = 1;
  normPower = Power[2, 1 / normPowerPower];
  previousAbsErrorMagnitude = 1000001; (* this is just something really big, in order for initial conditions to work *)
  absErrorMagnitude = 1000000; (* this is just something really big, but not quite as big as previous *)
  
  While[
    normPowerPower <= 6 && previousAbsErrorMagnitude - absErrorMagnitude > 0,
    previousAbsErrorMagnitude = absErrorMagnitude;
    previousSolution = solution;
    solution = getNumericalSolution[
      parts,
      normPower,
      unchangedIntervals,
      periodsPerOctave
    ];
    absErrorMagnitude = First[solution];
    normPowerPower = normPowerPower += 1;
    normPower = If[normPowerLimit == 1, Power[2, 1 / normPowerPower], Power[2, normPowerPower]];
  ];
  
  First[First[parts]] /. Last[solution]
];

getNumericalSolution[
  {
    temperedSideGeneratorsPart_,
    temperedSideMappingPart_,
    justSideGeneratorsPart_,
    justSideMappingPart_,
    eitherSideIntervalsPart_,
    eitherSideMultiplierPart_
  },
  normPower_,
  unchangedIntervals_,
  periodsPerOctave_
] := Module[
  {
    temperedSide,
    justSide,
    
    norm,
    minimizedNorm
  },
  
  temperedSide = First[getSide[temperedSideGeneratorsPart, temperedSideMappingPart, eitherSideIntervalsPart, eitherSideMultiplierPart]];
  justSide = First[getSide[justSideGeneratorsPart, justSideMappingPart, eitherSideIntervalsPart, eitherSideMultiplierPart]];
  
  norm = getNorm[normPower, temperedSide, justSide];
  minimizedNorm = If[
    Length[unchangedIntervals] > 0,
    {norm, First[temperedSideGeneratorsPart][[1]] == 1 / periodsPerOctave},
    norm
  ];
  
  NMinimize[minimizedNorm, First[temperedSideGeneratorsPart], WorkingPrecision -> nMinimizePrecision]
];

getNorm[normPower_, temperedSide_, justSide_] :=
    Norm[getErrors[temperedSide, justSide], normPower];

getSide[
  temperedOrJustSideGeneratorsPart_,
  temperedOrJustSideMappingPart_,
  eitherSideIntervalsPart_,
  eitherSideMultiplierPart_
] := temperedOrJustSideGeneratorsPart.temperedOrJustSideMappingPart.eitherSideIntervalsPart.eitherSideMultiplierPart;
