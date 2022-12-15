@ECHO %2

ECHO xlsxwriter > "C:\Program Files\URSProd\requirements.txt"
ECHO sqldbwrpr >> "C:\Program Files\URSProd\requirements.txt"
ECHO displayfx >> "C:\Program Files\URSProd\requirements.txt"
ECHO beetools >> "C:\Program Files\URSProd\requirements.txt"
c:
rd /S /Q "D:\Dropbox\Projects\URSProd"
md "C:\Program Files\URSProd"
cd "C:\Program Files\URSProd"
pip install --upgrade --force -r "C:\Program Files\URSProd\requirements.txt"
pip install --upgrade --force d:\Dropbox\Projects\FideratingList
pip install --upgrade --force d:\Dropbox\Projects\fidewebtourparser
pip install --upgrade --force d:\Dropbox\Projects\dateid
copy "D:\Dropbox\Projects\ResultCollector\resultcollector\ResultCollector.py" "C:\Program Files\URSProd"
copy "D:\Dropbox\Projects\ResultCollector\resultcollector\MonthEnd_w.*" "C:\Program Files\URSProd"
copy "D:\Dropbox\Projects\ResultCollector\resultcollector\AdHoc_w.*" "C:\Program Files\URSProd"