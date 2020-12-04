#!/bin/sh

numb='3112'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 5 --keyint 260 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.4,1.0,3.8,0.5,0.9,0.0,2,1,10,5,260,4,21,30,5,4,60,48,1,1000,-2:-2,dia,crop,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"