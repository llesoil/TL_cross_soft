#!/bin/sh

numb='2340'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 25 --keyint 280 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.4,4.2,0.2,0.7,0.6,1,0,2,25,280,2,25,0,3,2,69,48,4,2000,-1:-1,dia,crop,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"