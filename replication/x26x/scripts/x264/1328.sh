#!/bin/sh

numb='1329'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 0 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.0,1.2,0.2,0.3,0.9,0.7,3,0,12,0,220,0,26,50,3,3,67,18,6,2000,-1:-1,umh,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"