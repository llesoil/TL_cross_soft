#!/bin/sh

numb='1371'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 20 --keyint 280 --lookahead-threads 4 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.2,1.3,3.4,0.6,0.8,0.3,3,1,2,20,280,4,20,10,3,4,63,28,2,2000,-2:-2,umh,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"