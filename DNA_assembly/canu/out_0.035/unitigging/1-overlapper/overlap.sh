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

if [ $jobid -eq 1 ] ; then
  bat="001"
  job="001/000001"
  opt="-h 1-22778 -r 1-22778 --hashdatalen 160006229"
fi

if [ $jobid -eq 2 ] ; then
  bat="001"
  job="001/000002"
  opt="-h 22779-43822 -r 1-43822 --hashdatalen 160006650"
fi

if [ $jobid -eq 3 ] ; then
  bat="001"
  job="001/000003"
  opt="-h 43823-67023 -r 1-67023 --hashdatalen 160003794"
fi

if [ $jobid -eq 4 ] ; then
  bat="001"
  job="001/000004"
  opt="-h 67024-88104 -r 1-88104 --hashdatalen 160001948"
fi

if [ $jobid -eq 5 ] ; then
  bat="001"
  job="001/000005"
  opt="-h 88105-110131 -r 1-110131 --hashdatalen 160006023"
fi

if [ $jobid -eq 6 ] ; then
  bat="001"
  job="001/000006"
  opt="-h 110132-132602 -r 1-132602 --hashdatalen 160009299"
fi

if [ $jobid -eq 7 ] ; then
  bat="001"
  job="001/000007"
  opt="-h 132603-155323 -r 1-155323 --hashdatalen 160004892"
fi

if [ $jobid -eq 8 ] ; then
  bat="001"
  job="001/000008"
  opt="-h 155324-167874 -r 1-167874 --hashdatalen 89144647"
fi


if [ ! -d ./$bat ]; then
  mkdir ./$bat
fi


if [ -e $job.ovb ]; then
  exists=true
else
  exists=false
fi
if [ $exists = true ] ; then
  echo Job previously completed successfully.
  exit
fi

#  Fetch the frequent kmers, if needed.
if [ ! -e ../0-mercounts/canu_assembly.ms22.dump ] ; then
  mkdir -p ../0-mercounts
  cd ../0-mercounts
  cd -
fi


$bin/overlapInCore \
  -t 8 \
  -k 22 \
  -k ../0-mercounts/canu_assembly.ms22.dump \
  --hashbits 23 \
  --hashload 0.8 \
  --maxerate  0.035 \
  --minlength 500 \
  $opt \
  -o ./$job.ovb.WORKING \
  -s ./$job.stats \
  ../../canu_assembly.seqStore \
&& \
mv ./$job.ovb.WORKING ./$job.ovb


exit 0
