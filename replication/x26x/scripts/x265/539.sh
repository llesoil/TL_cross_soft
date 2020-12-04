#!/bin/sh

numb='540'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 35 --keyint 290 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.3,1.3,2.6,0.2,0.7,0.0,3,1,2,35,290,0,20,0,5,3,65,48,5,2000,-1:-1,dia,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"