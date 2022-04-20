failures = 0;
passes = 0;

testClose[fn_, args___, expectation_] := Module[{actual},
  actual = Apply[fn, {args}];
  
  If[
    AllTrue[MapThread[Abs[#1 - #2] < 0.001&, {actual, expectation}], TrueQ],
    passes += 1,
    failures += 1;
    Print[Style[StringForm["``[``] != ``; actual result was:", fn, {args}, SetAccuracy[expectation, 4]], 14, Red]];
    Print[ToString[SetAccuracy[actual, 4]]];
  ]
];


(* GENERATORS PREIMAGE TRANSVERSAL *)


(* getGpt *)
test[getGpt, {{{1, 1, 0}, {0, 1, 4}}, "co"}, {{{1, 0, 0}, {-1, 1, 0}}, "contra"}];
test[getGpt, {{{4, -4, 1}}, "contra"}, {{{1, 0, 0}, {0, 1, 0}}, "contra"}];


(* TUNING *)

(* some temperaments to check against *)

meantone = {{{1, 1, 0}, {0, 1, 4}}, "co"};
blackwood = {{{5, 8, 0}, {0, 0, 1}}, "co"};
dicot = {{ {1, 1, 2}, {0, 2, 1}}, "co"};
augmented = {{{3, 0, 7}, {0, 1, 0}}, "co"};
mavila = {{{1, 0, 7}, {0, 1, -3}}, "co"};
porcupine = {{{1, 2, 3}, {0, 3, 5}}, "co"};
srutal = {{{2, 0, 11}, {0, 1, -2}}, "co"};
hanson = {{{1, 0, 1}, {0, 6, 5}}, "co"};
magic = {{{1, 0, 2}, {0, 5, 1}}, "co"};
negri = {{{1, 2, 2}, {0, -4, 3}}, "co"};
tetracot = {{{1, 1, 1}, {0, 4, 9}}, "co"};
meantone7 = {{{1, 0, -4, -13}, {0, 1, 4, 10}}, "co"};
magic7 = {{{1, 0, 2, -1}, {0, 5, 1, 12}}, "co"};
pajara = {{{2, 3, 5, 6}, {0, 1, -2, -2}}, "co"};
augene = {{{3, 0, 7, 18}, {0, 1, 0, -2}}, "co"};
sensi = {{{1, -1, -1, -2}, {0, 7, 9, 13}}, "co"};
sensamagic = {{{1, 0, 0, 0}, {0, 1, 1, 2}, {0, 0, 2, -1}}, "co"};

(* optimizeGtm, by individual tuning properties *)

testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "unweighted", {1200.000, 696.578}];

testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1202.387, 697.173}];
testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1202.726, 697.258}];
testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", {1201.695, 697.563}];
testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, {1201.596, 697.530}];

testClose[optimizeGtm, meantone, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1202.390, 697.174}];
testClose[optimizeGtm, meantone, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1202.607, 696.741}];
testClose[optimizeGtm, meantone, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", {1201.698, 697.563}];
testClose[optimizeGtm, meantone, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, {1201.397, 697.049}];

testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "complexityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1197.613, 694.787}];
testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "complexityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1197.437, 694.976}];
testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "complexityWeighted", {1197.983, 694.712}];
testClose[optimizeGtm, meantone, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "complexityWeighted", "complexityNormPower" -> 2, {1198.160, 695.012}];


testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "unweighted", {1199.022, 695.601}];

testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1200.070, 696.005}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1200.742, 696.205}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "simplicityWeighted", {1200.985, 696.904}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, {1201.127, 696.905}];

testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "complexityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1198.396, 695.289}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "complexityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1198.244, 695.294}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "complexityWeighted", {1198.085, 694.930}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 2, "damageWeightingSlope" -> "complexityWeighted", "complexityNormPower" -> 2, {1197.930, 694.911}];


(*testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "unweighted", {1200.000, 696.578}];*)
optimizeGtm[meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "unweighted"];

testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1195.699, 693.352}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1195.699, 693.352}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "simplicityWeighted", {1200.000, 696.578}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, {1200.000, 696.578}];

testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "complexityWeighted", "complexityUnitsMultiplier" -> "unstandardized", {1200.000, 696.578}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "complexityWeighted", "complexityUnitsMultiplier" -> "unstandardized", "complexityNormPower" -> 2, {1200.000, 696.578}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "complexityWeighted", {1195.699, 693.352}];
testClose[optimizeGtm, meantone, "optimizationPower" -> 1, "damageWeightingSlope" -> "complexityWeighted", "complexityNormPower" -> 2, {1195.699, 693.352}];


(* optimizeGtm, by "systematicTuningName" *)
(* TODO: you should probably instead just test that these map to the correct traits, or something *)
(* TODO: you should make some diagrams and actually visually check some of these non-unique ones for pajara *)

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-U", {600.000, 108.125}];

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-MS", {596.496, 106.108}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-MES", {598.230, 106.547}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-S", {598.444, 107.706}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-ES", {599.682, 108.372}];

testClose[optimizeGtm, pajara, "tim" -> {}, "systematicTuningName" -> "minimax-MS", {597.123, 103.304}];
testClose[optimizeGtm, pajara, "tim" -> {}, "systematicTuningName" -> "minimax-MES", {598.345, 106.693}];
testClose[optimizeGtm, pajara, "tim" -> {}, "systematicTuningName" -> "minimax-S", {598.451, 106.578}];
testClose[optimizeGtm, pajara, "tim" -> {}, "systematicTuningName" -> "minimax-ES", {598.859, 106.844}];

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-MC", {601.517, 108.012}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-MEC", {601.829, 108.324}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-C", {601.556, 108.012}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minimax-EC", {600.318, 108.185}];


testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-U", {599.450, 107.15}];

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-MS", {597.851, 106.643}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-MES", {598.310, 106.798}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-S", {598.436, 106.672}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-ES", {598.762, 106.835}];

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-MC", {601.653, 107.288}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-MEC", {601.522, 107.178}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-C", {600.655, 107.426}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisos-EC", {600.263, 107.259}];


testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-U", {600.000, 106.843}];

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-MS", {597.851, 106.643}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-MES", {598.310, 106.798}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-S", {598.436, 106.672}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-ES", {598.762, 106.835}];

testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-MC", {601.397, 106.145}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-MEC", {601.397, 106.145}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-C", {600.000, 106.843}];
testClose[optimizeGtm, pajara, "systematicTuningName" -> "minisum-EC", {600.000, 106.843}];


(* optimizeGtm, by "originalTuningName" *)
(* TODO: you should probably instead just test that these map to the correct traits, or something *)

(* this is simply some coverage that they match the above *)
testClose[optimizeGtm, pajara, "originalTuningName" -> "minimax", {600.000, 106.843}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "least squares", {599.450, 107.15}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "TOP", {598.451, 106.578}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "TIPTOP", {598.451, 106.578}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "TE", {598.859, 106.844}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "Frobenius", {598.345, 106.693}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "POTE", {600.000, 107.048}]; (* TODO: this is weird example for PO b/c not pure octave, I mean it's good to have this, but not as the first and only example *)
testClose[optimizeGtm, pajara, "originalTuningName" -> "POTOP", {600.000, 106.854}];
testClose[optimizeGtm, pajara, "originalTuningName" -> "POTT", {600.000, 106.854}];
(* TODO: include inharmonic TE in my list of originalTuningName (and support in systematicTuningName somehow... do something for now, and then ask Dave what he thinks) *)

(* and then in this section I want to have a bunch of external examples, organized by tuning first, then temperament
sources:
[1] Facebook
[1a] https://www.facebook.com/groups/xenharmonicmath/posts/2363908480416027/?comment_id=2363994823740726 
[2] Yahoo posts
[2a] https://yahootuninggroupsultimatebackup.github.io/tuning-math/topicId_21029.html
[3] Graham's temperament app
[3a] 
[4] Flora's temperament app
[5] Paul's papers
[5a] 
[6] Graham's paper
[6a] 
[7] Xen wiki
[7a]
*)

(* minimax *)
(* TODO: gather some *)

(* least squares *)
(* TODO: gather some *)

(* TOP / TIPTOP *)
(* TODO: gather some *)

(* TE *)

testClose[optimizeTm, meantone, "originalTuningName" -> "TE", {1201.397, 1898.446, 2788.196}]; (* [1a] *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "TE", {1194.308, 1910.892, 2786.314}]; (* [1a] *)

(* Frobenius *)

(* POTE *)

testClose[optimizeTm, meantone, "originalTuningName" -> "POTE", {1200, 1896.239, 2784.955}]; (* [1a] *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "POTE", {1200, 1920, 2799.594}]; (* [1a] *)

(* POTOP / POTT *)
(* TODO: gather some *)

(* BOP *)
(* TODO: finish these tests; can find with Flora's code... but I don't trust it right now, it's still got my minkowksi and chebyshev stuff *)

testClose[optimizeTm, meantone, "originalTuningName" -> "BOP", {1200, 1900, 2790}];
testClose[optimizeTm, blackwood, "originalTuningName" -> "BOP", {1200, 1900, 2790}];

(* BE *)
(* TODO: not implemented yet, so this is just doing some who knows other tuning; this would involve the weighting matrix in the pseudoinverse style *)
testClose[optimizeTm, meantone, "originalTuningName" -> "BE", {1201.4768, 1898.6321, 2788.6213}]; (* [4] *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "BE", {1193.9975, 1910.396, 2790}]; (* [4], except that 2790 was a 0 but I changed so my test runner wouldn't grossly blow up for some unknown reason, but it should probably be a purely-tuned prime 5  *)

(* Weil *)
testClose[optimizeTm, meantone, "originalTuningName" -> "Weil", {1200.0, 1896.578, 2786.314}]; (* [2a] *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "Weil", {1188.722, 1901.955, 2773.22}]; (* [2a] *)
testClose[optimizeTm, dicot, "originalTuningName" -> "Weil", {1200.000, 1901.955, 2750.978}]; (* [2a] *)
testClose[optimizeTm, augmented, "originalTuningName" -> "Weil", {1194.134, 1897.307, 2786.314}]; (* [2a] *)
testClose[optimizeTm, mavila, "originalTuningName" -> "Weil", {1200.0, 1881.31, 2756.07}]; (* [2a] *)
testClose[optimizeTm, porcupine, "originalTuningName" -> "Weil", {1193.828, 1901.955, 2771.982}]; (* [2a] *)
testClose[optimizeTm, srutal, "originalTuningName" -> "Weil", {1198.222, 1901.955, 2786.314}]; (* [2a] *)
testClose[optimizeTm, hanson, "originalTuningName" -> "Weil", {1200.0, 1901.955, 2784.963}]; (* [2a] *)
testClose[optimizeTm, magic, "originalTuningName" -> "Weil", {1200.0, 1901.955, 2780.391}]; (* [2a] *)
testClose[optimizeTm, negri, "originalTuningName" -> "Weil", {1200.0, 1896.185, 2777.861}]; (* [2a] *)
testClose[optimizeTm, tetracot, "originalTuningName" -> "Weil", {1198.064, 1901.955, 2781.819}]; (* [2a] *)
testClose[optimizeTm, meantone7, "originalTuningName" -> "Weil", {1200.0, 1896.578, 2786.314 , 3365.784}]; (* [2a] *)
testClose[optimizeTm, magic7, "originalTuningName" -> "Weil", {1200.0, 1901.955, 2780.391, 3364.692}]; (* [2a] *)
testClose[optimizeTm, pajara, "originalTuningName" -> "Weil", {1193.803, 1896.996, 2771.924, 3368.826}]; (* [2a] *)
testClose[optimizeTm, augene, "originalTuningName" -> "Weil", {1194.134, 1899.852, 2786.314, 3365.102}]; (* [2a] *)
testClose[optimizeTm, sensi, "originalTuningName" -> "Weil", {1196.783, 1901.181, 2786.314, 3359.796}]; (* [2a] *)

(* WE *)
(* TODO: not implemented yet, so this is just doing some who knows other tuning; this would involve the weighting matrix in the pseudoinverse style *)

testClose[optimizeTm, meantone, "originalTuningName" -> "WE", {1201.391, 1898.436, 2788.182}]; (* [1a] *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "WE", {1194.254, 1910.807, 2786.189}]; (* [1a] *)

(* Kees *)
(* TODO: not passing yet *)

testClose[optimizeTm, meantone, "originalTuningName" -> "Kees", {1200., 1896.58, 2786.31}]; (* my own potop.m *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "Kees", {1200, 1920, 2801.37}]; (* my own potop.m *)

(* KE *)
(* TODO: not implemented yet, so this is just doing some who knows other tuning; this would involve the weighting matrix in the pseudoinverse style *)

testClose[optimizeTm, meantone, "originalTuningName" -> "KE", {1200, 1896.651, 2786.605}]; (* [1a] *)
testClose[optimizeTm, blackwood, "originalTuningName" -> "KE", {1200, 1920, 2795.126}]; (* [1a] *)


(* tuning equivalences *)

dummyTestFn[result_] := result;

(* logSopfr = TOP *)

checkLogSopfrIsTopConjecture[t_] := Module[{logSopfrTuning, topTuning},
  logSopfrTuning = optimizeGtm[t, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "logSopfr"];
  topTuning = optimizeGtm[t, "originalTuningName" -> "TOP"];
  
  testClose[dummyTestFn, logSopfrTuning, topTuning];
];
checkLogSopfrIsTopConjecture[meantone];
checkLogSopfrIsTopConjecture[blackwood];
checkLogSopfrIsTopConjecture[dicot];
checkLogSopfrIsTopConjecture[augmented];
checkLogSopfrIsTopConjecture[mavila];
checkLogSopfrIsTopConjecture[porcupine];
checkLogSopfrIsTopConjecture[srutal];
checkLogSopfrIsTopConjecture[hanson];
checkLogSopfrIsTopConjecture[magic];
checkLogSopfrIsTopConjecture[negri];
checkLogSopfrIsTopConjecture[tetracot];
checkLogSopfrIsTopConjecture[meantone7];
checkLogSopfrIsTopConjecture[magic7];
checkLogSopfrIsTopConjecture[pajara];
checkLogSopfrIsTopConjecture[augene];
checkLogSopfrIsTopConjecture[sensi];

(* sopfr = BOP *)

checkSopfrIsBopConjecture[t_] := Module[{sopfrTuning, bopTuning},
  sopfrTuning = optimizeGtm[t, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityUnitsMultiplier" -> "sopfr"];
  bopTuning = optimizeGtm[t, "originalTuningName" -> "BOP"];
  
  testClose[dummyTestFn, sopfrTuning, bopTuning];
];
checkSopfrIsBopConjecture[meantone];
checkSopfrIsBopConjecture[blackwood];
checkSopfrIsBopConjecture[dicot];
checkSopfrIsBopConjecture[augmented];
checkSopfrIsBopConjecture[mavila];
checkSopfrIsBopConjecture[porcupine];
checkSopfrIsBopConjecture[srutal];
checkSopfrIsBopConjecture[hanson];
checkSopfrIsBopConjecture[magic];
checkSopfrIsBopConjecture[negri];
checkSopfrIsBopConjecture[tetracot];
checkSopfrIsBopConjecture[meantone7];
checkSopfrIsBopConjecture[magic7];
checkSopfrIsBopConjecture[pajara];
checkSopfrIsBopConjecture[augene];
checkSopfrIsBopConjecture[sensi];

(* Kees = POTOP / POTT *)

checkKeesIsPotopConjecture[t_] := Module[{keesTuning, potopTuning},
  keesTuning = optimizeGtm[t, "originalTuningName" -> "Kees"];
  potopTuning = optimizeGtm[t, "originalTuningName" -> "POTOP"];
  
  testClose[dummyTestFn, keesTuning, potopTuning];
];
checkKeesIsPotopConjecture[meantone];
checkKeesIsPotopConjecture[blackwood];
checkKeesIsPotopConjecture[dicot];
checkKeesIsPotopConjecture[augmented];
checkKeesIsPotopConjecture[mavila];
checkKeesIsPotopConjecture[porcupine];
checkKeesIsPotopConjecture[srutal];
checkKeesIsPotopConjecture[hanson];
checkKeesIsPotopConjecture[magic];
checkKeesIsPotopConjecture[negri];
checkKeesIsPotopConjecture[tetracot];
checkKeesIsPotopConjecture[meantone7];
checkKeesIsPotopConjecture[magic7];
checkKeesIsPotopConjecture[pajara];
checkKeesIsPotopConjecture[augene];
checkKeesIsPotopConjecture[sensi];

(* KE \[TildeTilde] POTE *)

(* TODO: KE is still not implemented *)
checkKeIsPoteConjecture[t_] := Module[{},
  True
];
checkKeIsPoteConjecture[meantone];
checkKeIsPoteConjecture[blackwood];
checkKeIsPoteConjecture[dicot];
checkKeIsPoteConjecture[augmented];
checkKeIsPoteConjecture[mavila];
checkKeIsPoteConjecture[porcupine];
checkKeIsPoteConjecture[srutal];
checkKeIsPoteConjecture[hanson];
checkKeIsPoteConjecture[magic];
checkKeIsPoteConjecture[negri];
checkKeIsPoteConjecture[tetracot];
checkKeIsPoteConjecture[meantone7];
checkKeIsPoteConjecture[magic7];
checkKeIsPoteConjecture[pajara];
checkKeIsPoteConjecture[augene];
checkKeIsPoteConjecture[sensi];


(* interval basis *)
(* TODO: rename options to traits, if they really are traits *)
(* TODO: decide whether I really want to use camelCase for the user provided options, or sentence case maybe would be better*)
(* TODO: find and include more examples of this *)

t = {{{1, 1, 5}, {0, -1, -3}}, "co", {2, 7 / 5, 11}};
testClose[optimizeGtm, t, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, "tuningIntervalBasis" -> "formalPrimes", {1200.4181, 617.7581}];
testClose[optimizeGtm, t, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, "tuningIntervalBasis" -> "primes", {1200.0558, 616.4318}];

t = {{{1, 0, -4, 0}, {0, 1, 2, 0}, {0, 0, 0, 1}}, "co", {2, 9, 5, 21}};
testClose[optimizeGtm, t, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, "tuningIntervalBasis" -> "formalPrimes", {1201.3969, 3796.8919, 5270.7809}];
testClose[optimizeGtm, t, "tim" -> {}, "optimizationPower" -> \[Infinity], "damageWeightingSlope" -> "simplicityWeighted", "complexityNormPower" -> 2, "tuningIntervalBasis" -> "primes", {1201.3969, 3796.8919, 5267.2719}];


(* pure-octave stretch *)

(* TODO: test cover at all *)
(* TODO: test cover to error in the case that more than one generator row affects the first column *)
(* TODO: test cover to error if the subgroup doesn't include prime 2 *)
(* TODO: test cover to find prime 2 if it's not the first prime for some reason *)



(* ___ PRIVATE ___ *)



(* dualPower *)
test[dualPower, 1, \[Infinity]];
test[dualPower, 2, 2];
test[dualPower, \[Infinity], 1];

(* getPFromUnchangedIntervals *)
test[getPFromUnchangedIntervals, {{{1, 1, 0}, {0, 1, 4}}, "co"}, {{1, 0, 0}, {-2, 0, 1}}, {{1, 1, 0}, {0, 0, 0}, {0,FractionBox["1", "4"], 1}}];

(* getDiagonalEigenvalueMatrix *)
test[getDiagonalEigenvalueMatrix, {{1, 0, 0}, {-2, 0, 1}}, {{-4, 4, -1}}, {{1, 0, 0}, {0, 1, 0}, {0, 0, 0}}];

(* getPtm *)
test[getPtm, {{{12, 19, 28}}, "co", {2, 3, 5}}, {Log[2, 2], Log[2, 3], Log[2, 5]}];
test[getPtm, {{{1, 0, -4, 0}, {0, 1, 2, 0}, {0, 0, 0, 1}}, "co", {2, 9, 5, 21}}, {Log[2, 2], Log[2, 9], Log[2, 5], Log[2, 21]}];

(* getDiamond *)
test[getDiamond, 2, {{2, -1}, {-1, 1}}];
test[getDiamond, 3, {{2, -1, 0}, {3, 0, -1}, {-1, 1, 0}, {1, 1, -1}, {-2, 0, 1}, {0, -1, 1}}];
test[getDiamond, 4, {{2, -1, 0, 0}, {3, 0, -1, 0}, {3, 0, 0, -1}, {4, -2, 0, 0}, {-1, 1, 0, 0}, {1, 1, -1, 0}, {2, 1, 0, -1}, {-2, 0, 1, 0}, {0, -1, 1, 0}, {1, 0, 1, -1}, {1, -2, 1, 0}, {-2, 0, 0, 1}, {-1, -1, 0, 1}, {0, 0, -1, 1}, {1, -2, 0, 1}, {-3, 2, 0, 0}, {0, 2, -1, 0}, {0, 2, 0, -1}}];

(* octaveReduce *)
test[octaveReduce, 3, 3 / 2];
test[octaveReduce, 5, 5 / 4];
test[octaveReduce, 2 / 3, 4 / 3];

(* oddLimitFromD *)
test[oddLimitFromD, 2, 3];
test[oddLimitFromD, 3, 5];
test[oddLimitFromD, 4, 9];
test[oddLimitFromD, 5, 11];
test[oddLimitFromD, 6, 15];

(* getComplexity *)
test[getComplexity, {1, 1, -1}, {{{1, 2, 3}, {0, 5, 6}}, "co"}, "unstandardized", 1, 3];
test[getComplexity, {1, 1, -1}, {{{1, 2, 3}, {0, 5, 6}}, "co"}, "unstandardized", 2, \[Sqrt]3];
test[getComplexity, {1, 1, -1}, {{{1, 2, 3}, {0, 5, 6}}, "co"}, "standardized", 1, 1 +FractionBox[RowBox[{"Log", "[", "3", "]"}], RowBox[{"Log", "[", "2", "]"}]]+FractionBox[RowBox[{"Log", "[", "5", "]"}], RowBox[{"Log", "[", "2", "]"}]]];

(* getDamage *)
test[getDamage, meantone, {1201.7, 697.564}, "originalTuningName" -> "TOP", 0.00141543];
test[getDamage, meantone, {1199.02, 695.601}, "originalTuningName" -> "least squares", 0.0000729989];
test[getDamage, meantone, {1200., 696.578}, "originalTuningName" -> "minimax", 0.0179233];
(* TODO: I'm not sure this handles pure-octave stretch and interval basis properly *)



Print["TOTAL FAILURES: ", failures];
Print["TOTAL PASSES: ", passes];
