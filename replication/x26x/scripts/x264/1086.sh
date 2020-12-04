#!/bin/sh

numb='1087'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 45 --keyint 200 --lookahead-threads 4 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.4,1.2,3.2,0.6,0.8,0.8,1,2,6,45,200,4,22,10,4,1,60,48,1,2000,-1:-1,dia,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"