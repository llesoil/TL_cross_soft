#!/bin/sh

numb='2702'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 20 --keyint 270 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.3,1.2,2.8,0.4,0.9,0.4,3,2,10,20,270,2,28,50,5,2,68,48,4,2000,-1:-1,dia,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"