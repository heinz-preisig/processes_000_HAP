function self = reducesum(op1, reduceIndices)
  [lia, reduceIndicesPos] = ismember(reduceIndices, op1.indexLabels);
  assert(all(lia), 'Error: Reduce indices not in op1');

  indexLabels = op1.indexLabels;
  indexLabels(reduceIndicesPos) = [];

  independentIndices = setdiff(op1.indexLabels, reduceIndices);
  [~, independentPos] = ismember(independentIndices, op1.indexLabels);

  % Octave cant use yet vectdim as parameter for prod
  temp = op1.value;
  for i = 1:numel(reduceIndicesPos)
    temp = sum(temp, reduceIndicesPos(i));
  endfor

  % We get rid of the singleton dimensions resulting from prod by shifting them
  % to the end so they become trailing singleton dimensions.
  dimOrder = [independentPos, reduceIndicesPos];
  %   permute doesnt accept dimOrder arrays with less than 2 elements
  if numel(dimOrder) < 2
    value = temp;
  else
    value = permute(temp, dimOrder);
  endif

  self = MultiDimVar(indexLabels, [], op1.indexOrder, value);
endfunction