#!/bin/sh

numb='1846'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 10 --keyint 290 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.0,1.8,0.5,0.9,0.0,1,1,8,10,290,2,23,30,5,3,61,48,4,1000,1:1,umh,show,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"