#!/bin/sh

numb='1473'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.3,1.0,1.6,0.2,0.9,0.1,2,0,8,10,240,4,30,50,4,2,69,28,6,2000,-2:-2,umh,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"