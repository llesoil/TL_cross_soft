#!/bin/sh

numb='2255'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 5 --keyint 200 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.1,1.3,2.8,0.3,0.8,0.2,3,1,16,5,200,1,20,50,5,2,63,18,1,1000,-1:-1,dia,crop,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"