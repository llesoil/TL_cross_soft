#!/bin/sh

numb='962'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 1 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.1,1.0,4.6,0.5,0.7,0.5,0,0,2,15,210,1,24,20,5,4,66,48,6,1000,-2:-2,dia,show,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"