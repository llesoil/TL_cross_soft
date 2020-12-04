#!/bin/sh

numb='2371'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 0 --keyint 270 --lookahead-threads 2 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.1,1.3,3.8,0.4,0.9,0.7,0,0,12,0,270,2,26,0,3,1,61,18,3,2000,1:1,dia,show,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"