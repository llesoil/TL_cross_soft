#!/bin/sh

numb='2800'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 40 --keyint 290 --lookahead-threads 4 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.6,1.1,2.4,0.6,0.9,0.0,3,2,8,40,290,4,24,30,4,4,65,18,2,2000,-1:-1,umh,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"