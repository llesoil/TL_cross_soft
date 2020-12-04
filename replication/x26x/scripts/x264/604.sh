#!/bin/sh

numb='605'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 5 --keyint 270 --lookahead-threads 1 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.4,1.2,1.0,0.5,0.8,0.8,2,1,4,5,270,1,29,40,5,3,68,18,3,1000,-2:-2,umh,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"