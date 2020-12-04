#!/bin/sh

numb='1243'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 35 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.5,1.4,2.2,0.4,0.7,0.7,3,2,12,35,230,2,30,40,5,2,68,28,1,2000,-1:-1,umh,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"