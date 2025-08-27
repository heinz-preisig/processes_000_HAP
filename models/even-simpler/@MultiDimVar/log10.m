function self = log10(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     log10(op1.value));
endfunction