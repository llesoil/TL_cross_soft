#!/bin/sh

numb='3062'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 5.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,--no-asm,--slow-firstpass,--no-weightb,2.0,1.2,1.1,5.0,0.6,0.6,0.2,1,0,2,20,240,2,22,20,4,0,62,18,1,1000,-2:-2,dia,show,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"