function self = minus(op1, op2)
  assert(
    isequal(op1.indexLabels, op2.indexLabels),
    sprintf(
      "Error: IndexLabels do not match (%s) != (%s)",
      strjoin(op1.indexLabels, ', '), strjoin(op2.indexLabels, ', ')
    )
  )
  assert(
    isequal(size(op1), size(op2)),
    sprintf(
      "Error: Nonconformant arguments (op1 is %s, op2 is %s)",
      formatsize(op1), formatsize(op2)
    )
  )
  value = op1.value - op2.value;
  indexLabels = op1.indexLabels;

  self = MultiDimVar(indexLabels, size(value), op1.indexOrder, value);
endfunction