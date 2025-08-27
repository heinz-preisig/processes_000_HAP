function self = sign(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     sign(op1.value));
endfunction