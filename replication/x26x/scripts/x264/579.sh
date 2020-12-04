#!/bin/sh

numb='580'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 50 --keyint 210 --lookahead-threads 1 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.2,4.2,0.4,0.8,0.8,3,2,16,50,210,1,24,0,4,2,68,18,3,2000,-1:-1,umh,crop,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"