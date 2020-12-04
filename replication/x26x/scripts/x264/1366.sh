#!/bin/sh

numb='1367'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 35 --keyint 200 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.0,1.0,3.0,0.2,0.8,0.5,3,1,12,35,200,0,27,50,3,0,65,28,6,2000,-1:-1,hex,crop,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"