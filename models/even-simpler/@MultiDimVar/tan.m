function self = tan(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     tan(op1.value));
endfunction