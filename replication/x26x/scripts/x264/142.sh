#!/bin/sh

numb='143'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.0,1.1,2.6,0.5,0.9,0.4,1,0,14,40,300,1,25,20,4,4,62,28,5,2000,-1:-1,dia,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"