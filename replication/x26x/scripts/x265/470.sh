#!/bin/sh

numb='471'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 25 --keyint 230 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.2,1.3,3.6,0.6,0.9,0.4,1,1,6,25,230,3,25,0,5,0,66,28,3,1000,-2:-2,dia,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"