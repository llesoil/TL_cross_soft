#!/bin/sh

numb='2905'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.1,0.8,0.3,0.7,0.4,2,0,8,45,210,2,24,40,3,2,68,48,3,1000,-1:-1,dia,crop,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"