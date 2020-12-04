#!/bin/sh

numb='1227'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 10 --keyint 230 --lookahead-threads 4 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.2,4.6,0.2,0.7,0.9,1,1,12,10,230,4,28,20,3,2,60,48,4,2000,-2:-2,dia,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"