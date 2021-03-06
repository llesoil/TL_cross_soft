#!/bin/sh

numb='19'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 20 --keyint 200 --lookahead-threads 2 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.2,3.4,0.5,0.7,0.4,2,1,2,20,200,2,29,50,4,0,61,28,6,2000,1:1,hex,crop,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"