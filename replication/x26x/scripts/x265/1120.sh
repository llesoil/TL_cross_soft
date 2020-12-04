#!/bin/sh

numb='1121'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 30 --keyint 230 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.5,1.3,4.0,0.5,0.6,0.8,1,2,12,30,230,3,20,40,4,2,62,48,6,1000,-1:-1,umh,crop,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"