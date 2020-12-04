#!/bin/sh

numb='700'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 5 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.1,0.2,0.3,0.6,0.3,2,2,0,5,280,3,29,40,5,3,63,38,4,1000,-1:-1,hex,show,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"