#!/bin/sh

numb='262'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.3,2.8,0.2,0.8,0.0,1,1,4,45,300,0,29,10,5,0,69,18,3,2000,-1:-1,dia,crop,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"