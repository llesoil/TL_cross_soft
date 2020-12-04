#!/bin/sh

numb='1558'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 30 --keyint 270 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.4,1.0,4.8,0.6,0.7,0.2,2,2,4,30,270,2,30,10,3,0,62,18,3,1000,-1:-1,hex,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"