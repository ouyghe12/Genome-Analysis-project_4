#!/bin/sh


#  Path to Canu.

bin="/sw/bioinfo/canu/2.2/rackham/bin"

#  Report paths.

echo ""
echo "Found perl:"
echo "  " `which perl`
echo "  " `perl --version | grep version`
echo ""
echo "Found java:"
echo "  " `which /sw/comp/java/x86_64/sun_jdk1.8.0_151/bin/java`
echo "  " `/sw/comp/java/x86_64/sun_jdk1.8.0_151/bin/java -showversion 2>&1 | head -n 1`
echo ""
echo "Found canu:"
echo "  " $bin/canu
echo "  " `$bin/canu -version`
echo ""


#  Environment for any object storage.

export CANU_OBJECT_STORE_CLIENT=
export CANU_OBJECT_STORE_CLIENT_UA=
export CANU_OBJECT_STORE_CLIENT_DA=
export CANU_OBJECT_STORE_NAMESPACE=
export CANU_OBJECT_STORE_PROJECT=





/sw/bioinfo/canu/2.2/rackham/bin/sqStoreCreate \
  -o ./canu_assembly.seqStore.BUILDING \
  -minlength 1000 \
  -genomesize 50000000 \
  -coverage   200 \
  -bias       0 \
  -corrected -trimmed -pacbio canu_assembly.trimmedReads /scratch/9418725/ooo/canu_assembly.trimmedReads.fasta.gz \
&& \
mv ./canu_assembly.seqStore.BUILDING ./canu_assembly.seqStore \
&& \
exit 0

exit 1
