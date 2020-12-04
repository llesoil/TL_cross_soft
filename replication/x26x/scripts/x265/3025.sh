#!/bin/sh

numb='3026'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.1,1.3,4.6,0.6,0.9,0.8,0,2,8,5,300,1,24,50,5,3,60,28,4,2000,-2:-2,umh,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"