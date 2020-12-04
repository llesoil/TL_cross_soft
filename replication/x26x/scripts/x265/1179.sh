#!/bin/sh

numb='1180'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 25 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.5,1.0,1.2,0.6,0.8,0.9,2,2,2,25,250,2,29,40,3,2,69,48,2,1000,-2:-2,dia,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"