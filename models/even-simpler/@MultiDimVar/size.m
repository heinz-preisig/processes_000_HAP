function varargout = size(self, varargin)
  [varargout{1:nargout}] = builtin('size', self.value, varargin{:});

  % For singleton dimensions at the end
  if length(self.indexLabels) > length(varargout{1})
    % Append ones to the size vector
    extra_ones = ones(1, length(self.indexLabels) - length(varargout{1}));
    varargout{1} = [varargout{1}, extra_ones];
  endif
end
