#!/bin/sh

numb='1977'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 5 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.2,1.2,2.8,0.5,0.8,0.6,1,0,4,5,250,2,29,20,3,0,64,28,5,1000,-1:-1,umh,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"