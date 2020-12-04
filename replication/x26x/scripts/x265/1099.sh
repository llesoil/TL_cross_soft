#!/bin/sh

numb='1100'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 40 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.5,1.0,4.6,0.6,0.8,0.7,1,1,4,40,250,4,23,20,3,3,67,28,6,1000,-2:-2,dia,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"