#!/bin/sh

numb='2437'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.2,1.2,2.0,0.2,0.8,0.9,1,2,10,30,300,4,24,40,3,4,69,28,3,2000,-1:-1,dia,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"