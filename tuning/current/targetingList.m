(* covers targeting-list (includes 
pure-octave-constrained minimax-U "minimax", pure-octave-constrained minisos-U "least squares") *)
optimizeGeneratorsTuningMapTargetingList[tuningOptions_] := Module[
  {unchangedIntervals, optimizationPower, complexityMakeOdd},
  
  If[tuningOption[tuningOptions, "debug"], Print["targeting-list"]];
  
  unchangedIntervals = tuningOption[tuningOptions, "unchangedIntervals"];
  optimizationPower = tuningOption[tuningOptions, "optimizationPower"];
  complexityMakeOdd = tuningOption[tuningOptions, "complexityMakeOdd"];
  
  If[
    Length[unchangedIntervals] > 0 || complexityMakeOdd == True,
    
    (* no historically described tunings use this *)
    optimizeGeneratorsTuningMapMinisop[tuningOptions],
    
    If[
      optimizationPower == 2,
      
      (* covers least squares *)
      optimizeGeneratorsTuningMapMinisos[tuningOptions],
      
      If[
        optimizationPower == \[Infinity],
        
        (* covers minimax *)
        optimizeGeneratorsTuningMapMinimax[tuningOptions],
        
        If[
          optimizationPower == 1,
          
          (* no historically described tunings use this *)
          optimizeGeneratorsTuningMapMinisum[tuningOptions],
          
          (* no historically described tunings use this *)
          optimizeGeneratorsTuningMapMinisop[tuningOptions]
        ]
      ]
    ]
  ]
];

(* covers pure-octave-constrained minimax-U "minimax" *)
optimizeGeneratorsTuningMapMinimax[tuningOptions_] := Module[
  {t, complexitySizeFactor, targetedIntervalsA, damageWeights},
  
  If[tuningOption[tuningOptions, "debug"], Print["minimax"]];
  
  t = tuningOption[tuningOptions, "t"];
  complexitySizeFactor = tuningOption[tuningOptions, "complexitySizeFactor"];
  targetedIntervalsA = tuningOption[tuningOptions, "targetedIntervalsA"];
  damageWeights = getDamageWeights[tuningOptions];
  
  optimizeGeneratorsTuningMapSemianalyticalMaxPolytope[t, targetedIntervalsA, damageWeights, complexitySizeFactor]
];

(* no historically described tunings use this *)
optimizeGeneratorsTuningMapMinisum[tuningOptions_] := Module[
  {
    t,
    targetedIntervalsA,
    
    optimizationPower,
    tuningMappings,
    tuningMap,
    targetedIntervalDamagesL
  },
  
  If[tuningOption[tuningOptions, "debug"], Print["minisum"]];
  
  t = tuningOption[tuningOptions, "t"];
  targetedIntervalsA = tuningOption[tuningOptions, "targetedIntervalsA"];
  
  (* if the solution from the sum polytope is non-unique, fall back to a power limit solution *)
  Check[
    optimizeGeneratorsTuningMapAnalyticalSumPolytope[tuningOptions, targetedIntervalsA, getSumDamage],
    
    If[tuningOption[tuningOptions, "debug"], Print["non-unique solution \[RightArrow] power limit solver"]];
    optimizationPower = tuningOption[tuningOptions, "optimizationPower"];
    tuningMappings = getTuningMappings[t];
    tuningMap = Part[tuningMappings, 3];
    targetedIntervalDamagesL = getTargetedIntervalDamagesL[tuningMap, tuningOptions];
    optimizeGeneratorsTuningMapNumericalPowerLimitSolver[tuningOptions, targetedIntervalDamagesL, optimizationPower]
  ]
];

(* covers pure-octave-constrained minisos-U "least squares" *)
optimizeGeneratorsTuningMapMinisos[tuningOptions_] := Module[
  {t(*, complexitySizeFactor *), targetedIntervalsA, damageWeights},
  
  If[tuningOption[tuningOptions, "debug"], Print["minisos"]];
  
  t = tuningOption[tuningOptions, "t"];
  (*  complexitySizeFactor = tuningOption[tuningOptions, "complexitySizeFactor"];*)
  targetedIntervalsA = tuningOption[tuningOptions, "targetedIntervalsA"];
  damageWeights = getDamageWeights[tuningOptions];
  
  optimizeGeneratorsTuningMapAnalyticalMagPseudoinverse[t, targetedIntervalsA, damageWeights(*, complexitySizeFactor*)]
];

(* no historically described tunings use this *)
optimizeGeneratorsTuningMapMinisop[tuningOptions_] := Module[
  {
    t,
    optimizationPower,
    
    tuningMappings,
    tuningMap,
    
    targetedIntervalDamagesL
  },
  
  If[tuningOption[tuningOptions, "debug"], Print["minisop"]];
  
  t = tuningOption[tuningOptions, "t"];
  optimizationPower = tuningOption[tuningOptions, "optimizationPower"];
  
  tuningMappings = getTuningMappings[t];
  tuningMap = Part[tuningMappings, 3];
  
  targetedIntervalDamagesL = getTargetedIntervalDamagesL[tuningMap, tuningOptions];
  
  optimizeGeneratorsTuningMapNumericalPowerSolver[tuningOptions, targetedIntervalDamagesL, optimizationPower]
];