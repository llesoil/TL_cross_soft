#!/bin/sh

numb='629'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 40 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.6,1.1,0.8,0.4,0.9,0.6,3,0,2,40,200,0,30,40,3,2,68,18,5,1000,-2:-2,umh,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"