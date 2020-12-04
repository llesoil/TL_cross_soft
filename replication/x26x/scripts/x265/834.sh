#!/bin/sh

numb='835'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 10 --keyint 300 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.5,1.1,3.4,0.5,0.9,0.0,0,0,16,10,300,1,30,10,4,1,68,48,2,2000,1:1,dia,show,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"