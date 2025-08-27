function str = mat2str(op1)
  str = sprintf("%s\n%s", mat2str(op1.value), char(op1.indexLabels));
endfunction