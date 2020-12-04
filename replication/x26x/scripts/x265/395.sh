#!/bin/sh

numb='396'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 5 --keyint 230 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.1,1.2,4.2,0.5,0.7,0.3,0,0,12,5,230,0,28,10,3,1,60,28,3,2000,-1:-1,umh,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"