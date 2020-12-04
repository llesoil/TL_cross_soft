#!/bin/sh

numb='2257'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 35 --keyint 300 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.2,1.0,4.8,0.4,0.9,0.2,2,1,12,35,300,0,28,30,4,4,65,48,6,1000,1:1,hex,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"