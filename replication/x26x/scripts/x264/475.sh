#!/bin/sh

numb='476'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 40 --keyint 280 --lookahead-threads 3 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.3,1.1,1.6,0.3,0.6,0.8,1,1,14,40,280,3,23,10,5,1,69,38,6,2000,-2:-2,hex,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"