#!/bin/sh

numb='796'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 5.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 40 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.0,1.3,1.3,5.0,0.6,0.9,0.7,0,0,16,40,220,1,21,40,5,4,67,28,5,2000,-1:-1,umh,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"