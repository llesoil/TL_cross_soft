#!/bin/sh

numb='1965'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 30 --keyint 220 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.5,1.2,1.1,0.6,0.3,0.9,0.7,2,0,0,30,220,0,22,0,4,2,63,38,2,1000,-2:-2,umh,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"