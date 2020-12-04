#!/bin/sh

numb='2338'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.2,1.3,3.6,0.5,0.6,0.5,3,2,0,30,230,1,26,10,3,0,61,48,1,1000,-2:-2,umh,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"