function str = formatsize(op1)
  % Auxiliary function to show the size as AxB instead of [A B]
  convertToCell = arrayfun(@(x)num2str(x), size(op1),'uni',0);
  str = strjoin(convertToCell, "x");
endfunction