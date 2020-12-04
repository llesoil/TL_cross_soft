#!/bin/sh

numb='2114'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.5,1.1,4.0,0.2,0.9,0.2,0,1,10,40,270,0,20,10,4,0,66,18,4,2000,-2:-2,dia,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"