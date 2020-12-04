#!/bin/sh

numb='1532'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 15 --keyint 230 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.6,1.1,0.6,0.5,0.8,0.4,3,0,14,15,230,1,21,10,4,3,66,18,3,2000,-1:-1,dia,show,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"