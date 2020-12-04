#!/bin/sh

numb='362'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 50 --keyint 250 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.3,1.1,4.6,0.3,0.9,0.5,2,2,12,50,250,1,24,10,3,4,61,28,2,1000,-1:-1,hex,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"