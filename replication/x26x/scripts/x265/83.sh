#!/bin/sh

numb='84'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 30 --keyint 210 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.3,1.0,1.6,0.5,0.8,0.4,2,2,16,30,210,0,27,10,5,3,67,48,2,1000,-1:-1,hex,show,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"