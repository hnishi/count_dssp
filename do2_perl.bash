#perl count_dssp.pl ss_tr_cut5000.txt # > out_do2.txt  
#perl count_dssp.pl ss_cut_tr.txt 
#perl count_dssp.pl ss_tr.txt  > out_do2.txt  

### VERSION 4.2 or later
#echo EEKK > in_do2.txt
#echo H >> in_do2.txt
#perl count_dssp.pl ss_tr_cut5000.txt < in_do2.txt  #> out_do2.txt  
#perl count_dssp.pl ss_tr.txt < in_do2.txt  #> out_do2.txt  

### VERSION 4.3 or later

### VERSION 5.0 or later
perl count_dssp.pl ss_tr_cut5000.txt << _EOF #> out_do2_1.txt 
4
..KK
....
4
EE[KR]K
HHHH
_EOF

# you must put a line after _EOF

### VERSION 4.4 or later
# regular expression
# . : any single character

