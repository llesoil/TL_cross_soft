#!/bin/sh

numb='1437'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.6,1.3,3.6,0.4,0.7,0.6,0,1,16,45,300,3,24,40,3,3,68,18,3,1000,-2:-2,hex,show,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"