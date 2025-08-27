function self = sqrt(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     sqrt(op1.value));
endfunction