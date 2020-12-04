#!/bin/sh

numb='809'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 0 --keyint 210 --lookahead-threads 1 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.3,1.0,4.2,0.6,0.7,0.1,0,0,8,0,210,1,29,20,4,4,66,48,2,1000,-1:-1,umh,crop,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"