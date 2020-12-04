#!/bin/sh

numb='369'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 30 --keyint 260 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.1,3.4,0.6,0.8,0.4,0,1,10,30,260,2,20,10,4,3,62,18,5,2000,-1:-1,hex,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"