#!/bin/sh

numb='2813'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.3,1.0,1.8,0.3,0.9,0.2,3,2,4,10,250,0,26,30,5,0,64,18,5,1000,-1:-1,dia,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"