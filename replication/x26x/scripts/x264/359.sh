#!/bin/sh

numb='360'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 10 --keyint 240 --lookahead-threads 1 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.5,1.3,3.8,0.4,0.7,0.2,2,1,0,10,240,1,25,0,3,1,66,28,4,2000,-1:-1,dia,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"