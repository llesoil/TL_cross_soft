#!/bin/sh

numb='2745'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.1,1.0,0.4,0.5,0.8,0.8,0,2,16,45,300,2,26,20,5,3,63,28,3,1000,-1:-1,hex,show,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"