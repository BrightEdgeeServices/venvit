@ECHO ON
%2\python -m pip install --upgrade pip
d:
cd D:\Projects\Colossus
pip install -e .
cd D:\Projects\%1
