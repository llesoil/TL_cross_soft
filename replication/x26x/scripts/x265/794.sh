#!/bin/sh

numb='795'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 25 --keyint 250 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.5,1.2,2.6,0.3,0.6,0.8,3,1,6,25,250,2,23,10,5,0,67,28,3,2000,-1:-1,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"