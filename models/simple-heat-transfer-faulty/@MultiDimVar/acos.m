function self = acos(op1)
  self = MultiDimVar(op1.indexLabels, size(op1), op1.indexOrder, ...
                     acos(op1.value));
endfunction