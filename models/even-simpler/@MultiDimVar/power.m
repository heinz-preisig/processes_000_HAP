function self = power(op1, op2)
  assert(
    isa(op1, "MultiDimVar") && isa(op2, "MultiDimVar"),
    "Error: Both operands need to be of type MultiDimVar."
  )
  assert(
    isequal(size(op1), size(op2)),
    "Error: Nonconformant arguments (op1 is %s, op2 is %s)",
    num2str(size(op1)), num2str(size(op2))
  )
  assert(
    isequal(op1.indexLabels, op2.indexLabels),
    sprintf(
      "Error: IndexLabels do not match (%s) != (%s)",
      strjoin(op1.indexLabels, ', '), strjoin(op2.indexLabels, ', ')
    )
  )

  indexLabels = op1.indexLabels;
  value = op1.value .^ op2.value;

  self = MultiDimVar(indexLabels, size(value), op1.indexOrder, value);
endfunction