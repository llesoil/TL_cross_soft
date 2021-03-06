#!/bin/sh

numb='1594'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 5 --keyint 250 --lookahead-threads 1 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.4,1.2,1.6,0.6,0.9,0.4,0,2,12,5,250,1,25,0,4,0,65,38,6,1000,-2:-2,hex,show,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"