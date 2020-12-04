#!/bin/sh

numb='304'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 5 --keyint 270 --lookahead-threads 1 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.1,4.6,0.5,0.7,0.6,1,2,0,5,270,1,25,10,5,1,63,38,1,1000,-1:-1,dia,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"