#!/bin/sh

numb='1360'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.5,1.4,0.6,0.6,0.7,0.9,2,0,0,45,300,0,23,10,3,4,62,28,5,1000,-1:-1,umh,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"