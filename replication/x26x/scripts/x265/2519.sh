#!/bin/sh

numb='2520'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 5 --keyint 210 --lookahead-threads 0 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.5,1.4,1.0,0.4,0.6,0.3,1,1,8,5,210,0,27,30,4,2,62,48,1,2000,-2:-2,hex,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"