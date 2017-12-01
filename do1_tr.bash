awk '{if( substr($1,0,1) == ">" && NR == 1){print $0}else if( substr($1,0,1) == ">" ){printf("\n%s\n",$0)}else{gsub("\n","");printf($0);}}END{print ""}' ../ss/ss.txt > ss_tr.txt
#ss_cut.txt > ss_cut_tr.txt

