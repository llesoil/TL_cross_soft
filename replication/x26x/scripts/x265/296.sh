#!/bin/sh

numb='297'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 20 --keyint 230 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.2,1.4,4.4,0.6,0.9,0.9,2,1,6,20,230,1,29,30,5,4,63,38,3,1000,-1:-1,umh,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"