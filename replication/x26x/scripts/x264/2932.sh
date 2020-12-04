#!/bin/sh

numb='2933'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 15 --keyint 280 --lookahead-threads 2 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.2,2.4,0.5,0.7,0.2,1,0,2,15,280,2,20,30,5,3,66,28,1,2000,-2:-2,hex,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"