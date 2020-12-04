#!/bin/sh

numb='2004'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 15 --keyint 280 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.2,1.6,0.2,0.7,0.8,1,2,8,15,280,1,24,10,4,2,67,28,3,2000,-2:-2,hex,show,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"