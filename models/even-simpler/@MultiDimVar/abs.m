function self = abs(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     abs(op1.value));
endfunction