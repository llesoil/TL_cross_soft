#!/bin/sh

numb='2111'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 35 --keyint 210 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.3,1.3,3.8,0.3,0.6,0.1,2,2,12,35,210,3,29,10,5,3,60,38,6,1000,-2:-2,hex,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"