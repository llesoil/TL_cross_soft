#!/bin/sh

numb='1082'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 40 --keyint 250 --lookahead-threads 1 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.4,1.2,0.5,0.8,0.3,1,1,14,40,250,1,23,40,4,1,61,28,5,2000,-1:-1,dia,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"