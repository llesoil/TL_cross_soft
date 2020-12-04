#!/bin/sh

numb='1571'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 20 --keyint 290 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.2,1.4,1.6,0.5,0.7,0.6,1,1,12,20,290,3,30,40,3,1,68,18,3,2000,-1:-1,umh,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"