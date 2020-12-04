#!/bin/sh

numb='1557'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 40 --keyint 210 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.3,1.0,4.8,0.2,0.9,0.0,3,2,2,40,210,0,25,40,5,2,67,18,1,2000,-1:-1,dia,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"