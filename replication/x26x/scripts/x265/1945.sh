#!/bin/sh

numb='1946'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 45 --keyint 220 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.1,1.2,0.4,0.5,0.7,0.9,2,1,2,45,220,3,20,10,3,1,63,18,3,2000,-2:-2,dia,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"