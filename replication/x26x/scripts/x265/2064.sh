#!/bin/sh

numb='2065'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 5 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.3,1.8,0.6,0.8,0.6,1,1,2,5,210,4,21,40,4,3,63,48,1,1000,-1:-1,dia,show,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"