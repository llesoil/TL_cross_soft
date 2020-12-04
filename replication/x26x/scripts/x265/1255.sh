#!/bin/sh

numb='1256'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 4 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.1,1.4,1.4,0.6,0.6,0.7,0,0,8,10,300,4,26,20,5,2,68,18,6,2000,-1:-1,umh,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"