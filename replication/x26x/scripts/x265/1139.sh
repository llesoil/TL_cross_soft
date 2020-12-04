#!/bin/sh

numb='1140'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 40 --keyint 280 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.3,1.2,3.8,0.6,0.9,0.1,3,2,6,40,280,4,21,40,5,0,61,18,5,1000,-2:-2,dia,crop,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"