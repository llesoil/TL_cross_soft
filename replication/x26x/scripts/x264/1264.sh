#!/bin/sh

numb='1265'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.0,1.1,3.8,0.6,0.9,0.3,3,0,2,15,210,4,25,20,5,3,69,18,6,2000,-1:-1,hex,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"