#!/bin/sh

numb='413'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 45 --keyint 200 --lookahead-threads 2 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.4,3.8,0.4,0.7,0.4,1,2,0,45,200,2,22,40,4,2,63,48,5,2000,1:1,umh,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"