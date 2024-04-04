cd $1

pdflatex -interaction=nonstopmode main.tex;
pdflatex -interaction=nonstopmode main.tex;

# okular main.pdf &


if [ $? -eq 0 ]
 then
   rm *.aux ;
   rm *.blg ;
   rm *.log ;
fi


