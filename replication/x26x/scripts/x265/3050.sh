#!/bin/sh

numb='3051'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.3,1.2,5.0,0.3,0.9,0.4,3,1,14,20,280,0,29,50,4,1,64,48,5,2000,-2:-2,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"