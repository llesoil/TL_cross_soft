#!/bin/sh

numb='56'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.3,1.1,4.2,0.2,0.6,0.3,2,1,16,20,210,2,23,30,4,1,67,48,5,1000,-1:-1,dia,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"