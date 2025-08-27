function self = rdivide(op1, op2)
  assert(isscalar(op1) || isscalar(op2) || isequal(size(op1), size(op2)),
    "Error: Nonconformant arguments (op1 is %s, op2 is %s)",
    num2str(size(op1)), num2str(size(op2))
  )

  % To account for scalars that are not MultiDimVar
  if ~isa(op1, "MultiDimVar")
    op1 = MultiDimVar({}, [1], op2.indexOrder, [op1]);
  endif
  if ~isa(op2, "MultiDimVar")
    op2 = MultiDimVar({}, [1], op1.indexOrder, [op2]);
  endif

  if length(op1.indexLabels) > length(op2.indexLabels)
    indexLabels = op1.indexLabels;
  else
    indexLabels = op2.indexLabels;
  endif

  value = op1.value ./ op2.value;

  self = MultiDimVar(indexLabels, size(value), op1.indexOrder, value);
endfunction