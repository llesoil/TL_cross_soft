#!/bin/sh

numb='520'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.3,1.2,2.2,0.6,0.6,0.0,1,0,12,15,240,2,24,30,5,1,65,18,2,2000,-2:-2,hex,crop,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"