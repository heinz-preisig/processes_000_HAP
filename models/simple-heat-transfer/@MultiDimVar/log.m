function self = log(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     log(op1.value));
endfunction