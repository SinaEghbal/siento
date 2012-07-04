if ($#ARGV < 1) {
	print "Usage: ConvertFileInput.pl SRC OUTPUT\n";
	exit(1);
}

$SRC = $ARGV[0];
$OUTPUT = $ARGV[1];

open SRC or die "Cannot open $SRC1 for reading\n";
open OUTPUT, ">$OUTPUT" or die "Cannot open $OUTPUT for writing\n";

$MAXFEATURENUM = 0;
$MINFEATURENUM = 1e7;
while ($LINE = <SRC>) {
   $LINE =~ tr/ /\:/;
   @sLine = split(/:/, $LINE);
   for ( $i = 1; $i < $#sLine; $i += 2) {
   	$MAXFEATURENUM = $sLine[$i] if ($MAXFEATURENUM < $sLine[$i]);
   	$MINFEATURENUM = $sLine[$i] if ($MINFEATURENUM > $sLine[$i]);
   }
}
close(SRC);
print "Min feature #: $MINFEATURENUM, Max feature #: $MAXFEATURENUM\n";

open SRC or die "Cannot open $SRC1 for reading\n";
$ind = 1;
while ($LINE = <SRC>) {
   chomp($LINE);	
   $LINE =~ tr/ /\:/;
   @sLine = split(/:/, $LINE);
   for ( $i = 1; $i < $#sLine; $i += 2) {
   	$feature_ind = $sLine[$i] - $MINFEATURENUM + 1;
   	print OUTPUT "$ind, $feature_ind, $sLine[$i+1]\n";
   }
   $feature_ind = $MAXFEATURENUM + 2 - $MINFEATURENUM;
   print OUTPUT "$ind, $feature_ind, $sLine[0]\n";
   	
   $ind++;
}
close(SRC);
