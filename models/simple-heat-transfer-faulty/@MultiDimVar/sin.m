function self = sin(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     sin(op1.value));
endfunction