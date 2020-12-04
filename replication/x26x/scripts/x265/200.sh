#!/bin/sh

numb='201'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.4,1.2,3.4,0.6,0.6,0.0,0,0,16,40,230,4,28,40,5,4,68,48,5,2000,-1:-1,dia,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"