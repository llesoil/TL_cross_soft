#!/bin/sh

numb='1146'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 35 --keyint 290 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.5,1.0,1.3,1.8,0.2,0.9,0.3,3,0,10,35,290,3,29,0,4,2,61,28,5,2000,-2:-2,umh,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"