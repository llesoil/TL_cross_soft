#!/bin/sh

numb='2544'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.2,1.0,3.8,0.6,0.8,0.4,1,1,2,35,230,3,27,20,4,1,68,28,3,2000,-1:-1,dia,crop,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"