function bool = isequal(op1, op2)
  assert(
    isa(op1, "MultiDimVar") && isa(op2, "MultiDimVar"),
    "Error: Both operands need to be of type MultiDimVar"
  )
  if ~isequal(size(op1), size(op2))
    bool = false;
    return
  endif

  if isempty(op1.indexLabels) && isempty(op2.indexLabels)
    equal_labels = true;
  else
    equal_labels = isequal(op1.indexLabels, op2.indexLabels);
  endif

  equal_values = isequal(op1.value, op2.value);

  bool =  equal_labels && equal_values;
endfunction