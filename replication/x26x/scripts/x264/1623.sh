#!/bin/sh

numb='1624'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 45 --keyint 200 --lookahead-threads 0 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.2,1.0,4.2,0.2,0.8,0.6,1,1,12,45,200,0,21,50,4,1,60,18,4,2000,-1:-1,umh,show,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"