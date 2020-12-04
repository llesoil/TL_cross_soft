#!/bin/sh

numb='3101'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.1,0.4,0.6,0.6,0.7,3,1,12,45,240,2,21,50,4,1,69,18,3,1000,-2:-2,dia,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"