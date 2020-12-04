#!/bin/sh

numb='3031'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 15 --keyint 280 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.3,1.3,1.6,0.6,0.8,0.3,1,2,6,15,280,3,30,50,5,2,64,48,3,1000,1:1,umh,crop,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"