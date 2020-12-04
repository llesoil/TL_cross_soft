#!/bin/sh

numb='1378'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 10 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.2,1.4,3.6,0.5,0.8,0.0,2,2,14,10,280,0,25,50,4,0,66,38,2,1000,1:1,dia,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"