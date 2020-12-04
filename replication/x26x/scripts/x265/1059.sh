#!/bin/sh

numb='1060'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 15 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.1,1.0,2.4,0.3,0.6,0.2,0,1,6,15,230,0,23,20,5,0,68,38,6,2000,-2:-2,umh,show,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"