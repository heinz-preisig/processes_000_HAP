function self = subsref(op1, s)
  switch s(1).type
    case '()'
      % We only pass s(1) to the subref of value bc a matrix can only
      % accept () and there would be an error if chained subref is used.
      % Ex. A(3).value
      self = MultiDimVar(
        op1.indexLabels,
        size(op1.value),
        op1.indexOrder,
        builtin('subsref', op1.value, s(1))
      );

      % To handle chained subref
      if length(s) > 1
        s = s(2:end);
        self = subsref(self, s);
      endif      
    case '.'
      self = builtin('subsref', op1, s);
    case '{}'
      self = builtin('subsref', op1, s);
    otherwise
      error('Not a valid indexing expression')
  endswitch
endfunction