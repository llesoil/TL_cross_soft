#!/bin/sh

numb='985'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 25 --keyint 220 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.1,1.3,3.4,0.3,0.6,0.0,0,0,8,25,220,1,30,40,4,3,67,38,3,2000,1:1,umh,crop,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"