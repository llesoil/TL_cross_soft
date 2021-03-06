#!/bin/sh

numb='1017'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.6,1.3,2.0,0.3,0.8,0.5,1,2,8,35,230,3,28,0,4,2,63,48,5,2000,-1:-1,umh,crop,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"