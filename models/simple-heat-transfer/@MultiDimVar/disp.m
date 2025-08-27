function str = disp(op1)
  printf("Indices: ");
  if length(op1.indexLabels) == 0
    printf("None")
  else
    for i = 1:size(op1.indexLabels, 2)
      printf("%s ", op1.indexLabels{i});
    endfor
  endif
  printf("\n");
  disp(op1.value);
endfunction