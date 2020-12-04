#!/bin/sh

numb='2196'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.6,1.1,4.2,0.4,0.9,0.4,3,0,6,45,240,2,22,20,4,2,69,48,2,2000,-2:-2,umh,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"