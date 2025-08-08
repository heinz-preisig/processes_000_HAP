cd $1

# run it twice as longtable reports a change in row width...
# nasty mistake to find.....

pdflatex -interaction=nonstopmode $2 ;
pdflatex -interaction=nonstopmode $2 ;


# do not delete .toc
if [ $? -eq 0 ]
 then
   rm *.dvi ;
   rm *.ps ;
   rm *.bbl ;
   rm *.aux ;
   rm *.blg ;
   rm *.out; 
   rm *.log; 
   rm *.tex;
fi


#okular $2.pdf ;
