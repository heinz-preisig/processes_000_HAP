function self = exp(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     exp(op1.value));
endfunction