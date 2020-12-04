#!/bin/sh

numb='2605'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 40 --keyint 300 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.6,1.1,2.2,0.5,0.6,0.1,0,0,8,40,300,3,26,40,4,2,69,28,4,2000,1:1,dia,crop,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"