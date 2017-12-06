#!/bin/perl

### Ver 4.5
# Multiple input

use strict;
use warnings;

#*** SETTING ***
#my $filename = 'dssp_info_Final.txt';
my $filename = $ARGV[0];


my @seq1 = ();
my @ss1 = ();
my @seq_ss1 = ();
while (<STDIN>) {
  chomp($_);
  last if ($_ eq '');
  push(@seq1, $_);
  $_ = <STDIN>;
  chomp($_);
  last if ($_ eq '');
  push(@ss1, $_);
}

if(scalar @ss1 ne scalar @seq1)
{
  die "ERROR: Lines of input should be even number $!";
}

      foreach my $j (@seq1)
      {
        if($j =~ m/\[/)
        {
          print "I found [ \n";
        }
      }

#printf "Your input data\n";
for my $i (0..scalar(@ss1) -1) {
  #printf "%s\n", $i;
  #print "$seq1[$i], $ss1[$i] \n";
  $seq_ss1[$i] = $seq1[$i]."_".$ss1[$i];
}

my $n_query = scalar(@ss1);
print "number of input sets: $n_query\n";

#printf "Number of elements in \@arr: %d\n", scalar(@arr);


my %nhelix;
my %nf;
%nhelix=map{ $_ => 0 } @seq_ss1;
%nf=map{ $_ => 0 } @seq_ss1;
foreach my $j (@seq_ss1)
{
  #print "$j \n";
  $nhelix{$j} = 0;
  $nf{$j} = 0;
}

#*** CODE ***

## 20 amino acid residues
#my @aa = ('A','C','D','E','F','G','H','I','K','L','M','N','P','Q','R','S','T','V','W','Y'); 
## 7 secondary structures + none
#my @ss = ('H','B','E','G','I','T','S',' ');


open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "ERROR: Could not open file '$filename' $!";
 
# v4.0 2017/11/30
my $nhelix=0; my $nf=0; #normalization factor of KKEE

my $counter_pdb=0;
my $counter_all=0;
while (my $row = <$fh>) 
{
  $counter_pdb++;
  $row = <$fh>; # discard a line
  chomp $row;
  $counter_all+=length $row;
  #print "$counter_all \n";
  my @chars_aa = split("",$row);
  $row = <$fh>; # discard a line
  $row = <$fh>;
  chomp $row;
  my @chars_ss = split("",$row);
  #print "length: ", scalar @chars_aa, " ", scalar @chars_ss, "\n";
  if(scalar @chars_aa != scalar @chars_ss)
  {
    die "ERROR: The lengths of amino acid sequence and DSSP characters did not match at data $counter_pdb \n $!";
  }
  my $ii = 0;
  foreach my $i (@chars_aa)
  {

    my $i_query = 0;
    foreach my $iii (@seq_ss1)
    {
      #print "$seq1[$i_query]\n"; 
      my @target = split("",$seq1[$i_query]); 
      #print  scalar @target,"\n"; 
      my $ss = $ss1[$i_query]; 
      $i_query++;  
   
      my $jj = 0;
      my $flag1 = 0;
      my $flag2 = 0;
      my $flag3 = 0;

      if($ii >= scalar @target -1)
      {
        my $jjj = 0;
        foreach my $j (@target)
        {
          $flag2 = 0;
          $flag3 = 0;
          #print "DEBUG: ",$ii+1+$jjj-scalar @target ," ", $target[$jjj], "\n";
          #print "$chars_aa[1+$jjj] \n";
          if($chars_aa[$ii+1+$jjj-scalar @target] eq $j or $j eq ".")
          {
            $flag2 = 1;  
            if($chars_ss[$ii+1+$jjj-scalar @target] eq $ss)
            {
              $flag3 = 1;
            }
          }
          else {last;}
          #print "$j, $chars_aa[$ii+1+$jjj-scalar @target] \n";
          #print "$ss, $chars_ss[$ii+1+$jjj-scalar @target] \n";
          $jjj++;
        }
        $nf{$iii}++ if($flag2 == 1);
        $nhelix{$iii}++ if($flag3 == 1)
      }
    }
    $ii++;
  }
}

### OUTPUT SECTION

foreach my $iii (@seq_ss1)
{
  print "\n";
  if($nf{$iii} == 0){
    print "$iii\n";
    print "Nhelix = $nhelix{$iii}, Ntotal = $nf{$iii}, Ratio = NA \n";
    next;
  }
  my $ratio = $nhelix{$iii}/$nf{$iii} ;
  print "$iii\n";
  print "Nhelix = $nhelix{$iii}, Ntotal = $nf{$iii}, Ratio = $ratio \n";
}
print "\nThe number of chains in database: $counter_pdb \n";


