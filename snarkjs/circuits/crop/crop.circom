pragma circom 2.0.0;

template IsCrop(n) {
    signal input crop[2];
    
    signal cropSize;
    cropSize <-- crop[1] - crop[0] + 1;
    
    signal input pre[n];
    signal input post[n];
    
    signal output out;

    signal cropStart;
    cropStart <-- (crop[0] < 0) ? 0 : 1;
    
    signal cropEnd;
    cropEnd <-- (crop[1] >= n) ? 0 : 1;
    
    signal cropOrder;
    cropOrder <-- (crop[0] >= crop[1]) ? 0 : 1;
    
    signal cropRange;
    cropRange <-- (cropStart && cropEnd && cropOrder) ? 1 : 0;
    
    var pixMatches = 0;
    var padMatches = 0;
    for (var i = 0; i < n; i++) {
      if (i >= crop[0] && i <= crop[1]){
        pixMatches += (pre[i] == post[i]) ? 1 : 0;
      } else {
        padMatches += (post[i] == 0) ? 1 : 0;
      }
    }
    signal allPixMatch;
    allPixMatch <-- (pixMatches == cropSize) ? 1 : 0;
    signal allPadMatch;
    allPadMatch <-- (padMatches == n-cropSize) ? 1 : 0;
    
    signal imgMatch <-- (allPixMatch && allPadMatch) ? 1 : 0;
    
    out <== imgMatch;
}

component main = IsCrop(5);