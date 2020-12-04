#!/bin/sh

numb='2834'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 40 --keyint 260 --lookahead-threads 3 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.2,1.4,4.6,0.2,0.9,0.6,1,2,8,40,260,3,21,0,4,3,67,28,4,1000,-1:-1,dia,crop,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"