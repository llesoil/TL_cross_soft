#!/bin/sh

numb='2990'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.0,1.3,1.1,3.6,0.6,0.7,0.5,1,2,12,5,220,2,27,30,5,2,68,48,4,2000,-1:-1,dia,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"