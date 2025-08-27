function bool = isscalar(self)
  bool = builtin('isscalar', self.value);
endfunction