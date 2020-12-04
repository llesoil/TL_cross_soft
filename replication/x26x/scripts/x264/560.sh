#!/bin/sh

numb='561'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 30 --keyint 210 --lookahead-threads 3 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.2,1.3,2.0,0.3,0.6,0.6,3,1,16,30,210,3,25,40,3,3,63,18,1,2000,-2:-2,dia,crop,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"