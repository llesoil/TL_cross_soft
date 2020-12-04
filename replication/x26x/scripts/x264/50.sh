#!/bin/sh

numb='51'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.6,1.4,2.0,0.4,0.6,0.6,2,2,2,45,300,2,29,30,3,4,61,38,6,2000,1:1,dia,crop,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"