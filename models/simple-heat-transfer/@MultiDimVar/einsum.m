function self = einsum(op1, op2, reduceIndices)
  % Type verification
  assert(isa(op1, 'MultiDimVar') || isscalar(op1),
    'Error: Inputs must be of type MultiDimVar or a scalar');
  assert(isa(op2, 'MultiDimVar') || isscalar(op2),
    'Error: Inputs must be of type MultiDimVar or a scalar');

  % Convert scalar inputs to MultiDimVar objects.
  if ~isa(op1, "MultiDimVar") && isscalar(op1)
    op1 = MultiDimVar({}, [], op2.indexOrder, [op1]);
  endif

  if ~isa(op2, "MultiDimVar") && isscalar(op2)
    op2 = MultiDimVar({}, [], op1.indexOrder, [op2]);
  endif

  if nargin == 3
    [lia1, reduceIndicesPos1] = ismember(reduceIndices, op1.indexLabels);
    [lia2, reduceIndicesPos2] = ismember(reduceIndices, op2.indexLabels);

    assert(all(lia1),
      'Error: Reduce indices not in op1');
    assert(all(lia2),
      'Error: Reduce indices not in op2');

    reduceIndicesDimensions1 = size(op1)(reduceIndicesPos1);
    reduceIndicesDimensions2 = size(op2)(reduceIndicesPos2);

    assert(isequal(reduceIndicesDimensions1, reduceIndicesDimensions2),
      'Error: Reduce dimension mismatch %s != %s',
      mat2str(reduceIndicesDimensions1), mat2str(reduceIndicesDimensions2));

    reduceDimensionSize = prod(reduceIndicesDimensions1);
  else
    reduceIndices = {};
    reduceIndicesPos1 = [];
    reduceIndicesPos2 = [];
    reduceDimensionSize = 1;
  endif

  % For the pages
  commonIndices = intersect(op1.indexLabels, op2.indexLabels);
  pageIndices = setdiff(commonIndices, reduceIndices);

  [~, pagesPos1] = ismember(pageIndices, op1.indexLabels);
  [~, pagesPos2] = ismember(pageIndices, op2.indexLabels);

  pagesDimensions1 = size(op1)(pagesPos1);
  pagesDimensions2 = size(op2)(pagesPos2);

  assert(isequal(pagesDimensions1, pagesDimensions2),
      'Error: Page dimension mismatch %s != %s',
      mat2str(pagesDimensions1), mat2str(pagesDimensions2));

  pagesDimensionSize = prod(pagesDimensions1);

  % For the independent indices
  independentIndices1 = setdiff(op1.indexLabels, commonIndices);
  independentIndices2 = setdiff(op2.indexLabels, commonIndices);

  [~, independentPos1] = ismember(independentIndices1, op1.indexLabels);
  [~, independentPos2] = ismember(independentIndices2, op2.indexLabels);

  independentDimensions1 = size(op1)(independentPos1);
  independentDimensions2 = size(op2)(independentPos2);

  independentDimensionSize1 = prod(independentDimensions1);
  independentDimensionSize2 = prod(independentDimensions2);

  % Permutations
  dimOrder1 = [independentPos1, reduceIndicesPos1, pagesPos1];
  dimOrder2 = [reduceIndicesPos2, independentPos2, pagesPos2];

  %   permute doesnt accept dimOrder arrays with less than 2 elements
  if numel(dimOrder1) < 2
    permOp1 = op1.value;
  else
    permOp1 = permute(op1.value, dimOrder1);
  endif

  if numel(dimOrder2) < 2
    permOp2 = op2.value;
  else
    permOp2 = permute(op2.value, dimOrder2);
  endif

  % Reshape to 3D matrices (3rd dimension for the pages)
  resOp1 = reshape(permOp1, independentDimensionSize1, reduceDimensionSize, ...
    pagesDimensionSize);
  resOp2 = reshape(permOp2, reduceDimensionSize, independentDimensionSize2, ...
    pagesDimensionSize);

  % TODO: Change this to pagemtimes when octave catches up.
  resSize = [independentDimensionSize1, independentDimensionSize2, ...
    pagesDimensionSize];
  resValue = zeros(resSize);
  for i=1:pagesDimensionSize
    resValue(:,:,i) = resOp1(:,:,i) * resOp2(:,:,i);
  endfor

  % Reshaping back to a tensor
  valueDimensions = [independentDimensions1, independentDimensions2, ...
    pagesDimensions1];
  
  %   reshape doesnt accept arrays with less than 2 elements as the size
  if numel(valueDimensions) < 2
    valueDimensions = [valueDimensions, ones(1, 2 - numel(valueDimensions))];
  endif

  value = reshape(resValue, valueDimensions);
  indexLabels = [independentIndices1, independentIndices2, pageIndices];
  
  self = MultiDimVar(indexLabels, valueDimensions, op1.indexOrder, value);
endfunction