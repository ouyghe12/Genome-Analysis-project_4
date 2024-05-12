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




#  Discover the job ID to run, from either a grid environment variable and a
#  command line offset, or directly from the command line.
#
if [ x$CANU_LOCAL_JOB_ID = x -o x$CANU_LOCAL_JOB_ID = xundefined -o x$CANU_LOCAL_JOB_ID = x0 ]; then
  baseid=$1
  offset=0
else
  baseid=$CANU_LOCAL_JOB_ID
  offset=$1
fi
if [ x$offset = x ]; then
  offset=0
fi
if [ x$baseid = x ]; then
  echo Error: I need CANU_LOCAL_JOB_ID set, or a job index on the command line.
  exit
fi
jobid=`expr -- $baseid + $offset`
if [ x$baseid = x0 ]; then
  echo Error: jobid 0 is invalid\; I need CANU_LOCAL_JOB_ID set, or a job index on the command line.
  exit
fi
if [ x$CANU_LOCAL_JOB_ID = x ]; then
  echo Running job $jobid based on command line options.
else
  echo Running job $jobid based on CANU_LOCAL_JOB_ID=$CANU_LOCAL_JOB_ID and offset=$offset.
fi

if [ $jobid = 1 ] ; then
  minid=1
  maxid=15524
fi
if [ $jobid = 2 ] ; then
  minid=15525
  maxid=31201
fi
if [ $jobid = 3 ] ; then
  minid=31202
  maxid=44522
fi
if [ $jobid = 4 ] ; then
  minid=44523
  maxid=60507
fi
if [ $jobid = 5 ] ; then
  minid=60508
  maxid=75984
fi
if [ $jobid = 6 ] ; then
  minid=75985
  maxid=89183
fi
if [ $jobid = 7 ] ; then
  minid=89184
  maxid=104113
fi
if [ $jobid = 8 ] ; then
  minid=104114
  maxid=119756
fi
if [ $jobid = 9 ] ; then
  minid=119757
  maxid=134964
fi
if [ $jobid = 10 ] ; then
  minid=134965
  maxid=150693
fi
if [ $jobid = 11 ] ; then
  minid=150694
  maxid=165700
fi
if [ $jobid = 12 ] ; then
  minid=165701
  maxid=167874
fi
jobid=`printf %05d $jobid`

if [ -e ./$jobid.red ] ; then
  echo Job previously completed successfully.
  exit
fi

$bin/findErrors \
  -S ../../canu_assembly.seqStore \
  -O ../canu_assembly.ovlStore \
  -R $minid $maxid \
  -e 0.035 \
  -l 500 \
  -m 0.035 \
  -p 5 \
  -o ./$jobid.red.WORKING \
  -t 4 \
&& \
mv ./$jobid.red.WORKING ./$jobid.red


