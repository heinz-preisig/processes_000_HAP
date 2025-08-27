function self = subsasgn(self, s, varargin)
  switch s(1).type
    case '()'
      rhs = varargin{1};

      assert(isa(rhs, "MultiDimVar") || isnumeric(rhs),
          "Error: Invalid assignment, the value assigned must be of type MultiDimVar or numeric.",
          inputname(3)
      )

      if isa(rhs, "MultiDimVar")
        assert(isequal(self.indexLabels, rhs.indexLabels),
          "Error: Mismatching index labels. Expected %s; Obtained %s",
          inputname(3), strjoin(self.indexLabels, ""), strjoin(rhs.indexLabels, "")
        )
        rhsValue = rhs.value;
      else
        rhsValue = rhs;
      endif

      subsrefSelf = self.subsref(s);
      selfNumEl = numel(subsrefSelf.value);
      rhsNumEl = numel(rhsValue);
      selfSize = size(subsrefSelf.value);
      assert(isequal(selfNumEl, rhsNumEl),
          "Error: Nonconformant sizes. Expected %s; obtained %s",
          inputname(3), mat2str(selfSize), mat2str(size(rhsValue))
      )

      reshapedRhs = reshape(rhsValue, selfSize);

      self.value = builtin("subsasgn", self.value, s(1), reshapedRhs);
    case '.'
      self = builtin('subsasgn', self, s, varargin{:});
    case '{}'
      self = builtin('subsasgn', self, s, varargin{:});
    otherwise
      error('Not a valid indexing expression')
  endswitch
endfunction