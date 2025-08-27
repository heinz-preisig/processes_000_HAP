function self = atan(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     atan(op1.value));
endfunction