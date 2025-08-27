classdef MultiDimVar
  properties
    value
    indexLabels
    indexOrder
  endproperties
  methods
    function self = MultiDimVar(varargin)
      self.indexLabels = varargin{1};
      indexSizes = varargin{2};
      self.indexOrder = varargin{3};

      % Initialization to zero if no value is provided
      if nargin < 4
        if isscalar(indexSizes)
          self.value = zeros(indexSizes, 1);
        else
          self.value = zeros(indexSizes);
        endif
      else
        self.value = varargin{4};
      endif

      % Checking if the indexLabels are ordered correctly
      [~, newIndexOrder] = ismember(self.indexOrder, self.indexLabels);

      % Removing the zeros (indexLabels that are not in the current instance)
      newIndexOrder(newIndexOrder==0) = [];

      % Check if there is a need to reorder (in case is not ordered ascending)
      if ~isequal(newIndexOrder, sort(newIndexOrder))
        self.value = permute(self.value, newIndexOrder);
        self.indexLabels = self.indexLabels(newIndexOrder);
      endif

      % Transforming row vectors to column vectors
      if numel(self.indexLabels) == 1
        self.value = reshape(self.value, numel(self.value), 1);
      endif
    endfunction
    
    % Subscripted assignment and reference
    self = subsref(self, s)
    self = subsasgn(self, s, varargin)
    % Auxiliary functions
    fvarargout = size(self, varargin)
    bool = isscalar(self)
    bool = isvector(self)
    str = disp(op1)
    str = formatsize(op1)
    % Unitary functions and operators
    self = abs(op1)
    self = sign(op1)
    self = product(op1, reduceLabel)
    self = sparse(op1)
    self = exp(op1)
    self = log(op1)
    self = log10(op1)
    self = sqrt(op1)
    self = sin(op1)
    self = cos(op1)
    self = tan(op1)
    self = asin(op1)
    self = acos(op1)
    self = atan(op1)
    % Binary functions and operators
    bool = isequal(op1, op2)
    self = plus(op1, op2)
    self = minus(op1, op2)
    self = times(op1, op2)
    self = rdivide(op1, op2)
    self = expandproduct(op1, op2)
    self = mtimes(op1, op2)
    self = power(op1, op2)
  endmethods
endclassdef


