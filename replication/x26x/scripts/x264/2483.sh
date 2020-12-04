#!/bin/sh

numb='2484'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.6,1.3,1.8,0.6,0.9,0.2,3,0,2,50,210,2,23,10,4,4,62,28,3,2000,-2:-2,umh,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"