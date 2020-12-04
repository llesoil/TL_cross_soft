#!/bin/sh

numb='1043'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.0,1.3,1.0,0.3,0.6,0.9,1,0,2,15,250,0,26,40,5,0,63,28,5,1000,-1:-1,hex,crop,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"