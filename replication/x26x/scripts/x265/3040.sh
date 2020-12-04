#!/bin/sh

numb='3041'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.4,3.8,0.5,0.7,0.8,2,0,8,45,290,1,24,0,4,2,61,38,4,2000,1:1,umh,crop,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"