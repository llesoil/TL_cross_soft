#!/bin/sh

numb='290'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 10 --keyint 210 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.5,1.0,1.0,0.2,0.6,0.6,0.9,1,2,14,10,210,1,23,30,3,0,63,38,4,1000,-1:-1,umh,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"