#!/bin/sh

numb='1288'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.3,2.6,0.3,0.9,0.0,2,1,2,15,210,0,27,40,5,1,67,38,5,2000,-1:-1,hex,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"