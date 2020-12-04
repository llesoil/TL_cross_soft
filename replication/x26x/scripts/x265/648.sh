#!/bin/sh

numb='649'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.3,1.3,2.6,0.5,0.7,0.9,2,1,12,20,210,1,22,10,4,4,68,38,1,1000,-2:-2,umh,crop,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"