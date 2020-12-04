#!/bin/sh

numb='2627'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 40 --keyint 250 --lookahead-threads 3 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.6,1.1,3.0,0.2,0.8,0.1,0,2,14,40,250,3,27,30,4,0,64,48,3,2000,-2:-2,hex,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"