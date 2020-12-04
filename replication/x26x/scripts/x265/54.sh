#!/bin/sh

numb='55'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 10 --keyint 250 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.4,1.2,0.2,0.2,0.9,0.2,1,1,14,10,250,4,28,0,5,0,65,48,4,2000,-2:-2,dia,crop,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"